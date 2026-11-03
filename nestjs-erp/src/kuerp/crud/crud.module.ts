import {
  DynamicModule,
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Query,
  UseGuards,
  Inject,
  Module,
} from '@nestjs/common';
import { TypeOrmModule, getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ok } from '../../common/response.interceptor';
import { CrudService } from './crud.service';

/**
 * 通用 CRUD 控制器工厂：根据 entity + 路由 + 搜索字段，生成一套标准 REST 接口。
 * 接口路径形如 /kuerp/goods/index|get|add|edit|del，与原 FastAdmin 风格 1:1 对齐。
 */
function makeCrudController(route: string, searchFields: string[], token: symbol): any {
  @Controller(route)
  @UseGuards(JwtAuthGuard)
  class CrudController {
    constructor(@Inject(token) protected readonly svc: CrudService<any>) {}

    @Get('index')
    async index(@Query() q: any) {
      const r = await this.svc.index({ ...q, searchFields });
      return ok(r.list, 'success');
    }

    @Get('get')
    async get(@Query('id') id: string) {
      return ok(await this.svc.get(Number(id)));
    }

    @Post('add')
    async add(@Body() dto: any) {
      return ok(await this.svc.add(dto), '添加成功');
    }

    @Post('edit')
    async edit(@Body('id') id: string, @Body() dto: any) {
      return ok(await this.svc.edit(Number(id), dto), '保存成功');
    }

    @Delete('del')
    async del(@Body('id') id: string) {
      await this.svc.del(Number(id));
      return ok(null, '删除成功');
    }
  }
  return CrudController;
}

const tokenMap = new Map<string, symbol>();
function svcToken(entity: any): symbol {
  if (!tokenMap.has(entity.name)) tokenMap.set(entity.name, Symbol(`${entity.name}CrudService`));
  return tokenMap.get(entity.name)!;
}

/**
 * 通用 CRUD 模块工厂：为任意实体快速生成「controller + service + 仓储」。
 * 用法：CrudModuleFactory(GoodsEntity, 'kuerp/goods', ['goods_name','goods_code'])
 */
export function CrudModuleFactory(entity: any, route: string, searchFields: string[]): DynamicModule {
  const token = svcToken(entity);
  const controller = makeCrudController(route, searchFields, token);

  @Module({
    imports: [TypeOrmModule.forFeature([entity])],
    providers: [
      {
        provide: token,
        useFactory: (repo: Repository<any>) => new CrudService(repo),
        inject: [getRepositoryToken(entity)],
      },
    ],
    controllers: [controller],
    exports: [token],
  })
  class DynamicCrudModule {}

  return { module: DynamicCrudModule };
}
