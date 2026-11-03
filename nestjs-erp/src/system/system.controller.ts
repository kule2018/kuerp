import { Controller, Get, Post, Body, Query, Param, UseGuards, Delete } from '@nestjs/common';
import { SystemService } from './system.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { ok } from '../common/response.interceptor';
import { Admin } from './entities/admin.entity';

@Controller('system/admin')
@UseGuards(JwtAuthGuard)
export class SystemController {
  constructor(private readonly systemService: SystemService) {}

  /**
   * 管理员列表（分页 + 关键字搜索）。
   * @param page 页码，从 1 开始
   * @param limit 每页条数
   * @param search 关键字（匹配账号/昵称）
   * @returns 管理员数组
   */
  @Get('index')
  async index(@Query('page') page = 1, @Query('limit') limit = 10, @Query('search') search = '') {
    const data = await this.systemService.list({ page: +page, limit: +limit, search });
    return ok(data.list, 'success');
  }

  /**
   * 新增管理员。
   * @param dto 账号信息（username/password/nickname/group_id…）
   * @returns 新增后的记录（不含密码明文）
   */
  @Post('add')
  async add(@Body() dto: Partial<Admin>) {
    return ok(await this.systemService.create(dto), '添加成功');
  }

  /**
   * 修改管理员信息（密码为空表示不修改）。
   * @param id 管理员 ID
   * @param dto 待更新字段
   * @returns 更新后的记录
   */
  @Post('edit')
  async edit(@Body('id') id: number, @Body() dto: Partial<Admin>) {
    const data = await this.systemService.update(id, dto);
    return ok(data, '保存成功');
  }

  /**
   * 删除管理员（软删除）。
   * 同时提供 DELETE 与 POST 两种调用方式，与通用 kuerp 控制器惯例一致，
   * 避免部分 HTTP 客户端丢弃 DELETE body 导致删除失效。
   */
  @Delete('del')
  @Post('del')
  async del(@Body('id') id: number) {
    await this.systemService.remove(id);
    return ok(null, '删除成功');
  }
}
