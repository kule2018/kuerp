import { Injectable } from '@nestjs/common';

export interface IndexedDoc {
  id: string | number;
  content: string;
  source?: string;
  meta?: Record<string, any>;
}

export interface RetrievalHit {
  id: string | number;
  content: string;
  source?: string;
  meta?: Record<string, any>;
  score: number;
}

/**
 * 关键词检索服务：在内存索引上做轻量关键词召回（BM25 风格打分的简化版）。
 * 等效 Spring AI 的 VectorStore / QuestionAnswerAdvisor 的检索环节，
 * 用于把「相关资料」注入 Prompt 实现 RAG（此处用关键词而非向量，零依赖、可离线）。
 */
@Injectable()
export class KeywordRetrievalService {
  private readonly index = new Map<string, IndexedDoc[]>();

  /** 为一个数据集建立/覆盖索引 */
  indexDataset(dataset: string, docs: IndexedDoc[]) {
    this.index.set(dataset, docs);
  }

  /** 往已有数据集追加文档 */
  addDoc(dataset: string, doc: IndexedDoc) {
    const arr = this.index.get(dataset) || [];
    arr.push(doc);
    this.index.set(dataset, arr);
  }

  datasets(): string[] {
    return Array.from(this.index.keys());
  }

  /**
   * 关键词检索：对每条文档按关键词命中次数 + 字段覆盖度打分，返回 topK。
   * @param keyword 支持空格分隔的多关键词（AND 关系，命中越多分越高）
   */
  search(dataset: string, keyword: string, topK = 5): RetrievalHit[] {
    const docs = this.index.get(dataset);
    if (!docs || !keyword) return [];
    const terms = keyword.toLowerCase().split(/\s+/).filter(Boolean);
    const hits: RetrievalHit[] = [];
    for (const doc of docs) {
      const text = (doc.content || '').toLowerCase();
      let score = 0;
      let matchedTerms = 0;
      for (const term of terms) {
        let idx = text.indexOf(term);
        let count = 0;
        while (idx !== -1) {
          count++;
          idx = text.indexOf(term, idx + term.length);
        }
        if (count > 0) {
          matchedTerms++;
          score += count * (1 + term.length / 10);
        }
      }
      if (matchedTerms === terms.length && matchedTerms > 0) {
        hits.push({ ...doc, score });
      }
    }
    hits.sort((a, b) => b.score - a.score);
    return hits.slice(0, topK);
  }

  /** 把检索结果格式化为可注入 Prompt 的上下文文本 */
  static toContext(hits: RetrievalHit[]): string {
    if (!hits.length) return '（未检索到相关资料）';
    return hits
      .map((h, i) => `[${i + 1}] (${h.source || h.id}) ${h.content}`)
      .join('\n');
  }
}
