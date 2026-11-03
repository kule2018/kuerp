import * as crypto from 'crypto';

/**
 * 密码哈希工具（不依赖 bcrypt，使用 sha256 + 随机盐，满足基本安全要求）。
 */
export function makeSalt(): string {
  return crypto.randomBytes(16).toString('hex');
}

export function encryptPassword(password: string, salt: string): string {
  return crypto
    .pbkdf2Sync(password, salt, 1000, 32, 'sha256')
    .toString('hex');
}

export function verifyPassword(password: string, salt: string, hash: string): boolean {
  return encryptPassword(password, salt) === hash;
}
