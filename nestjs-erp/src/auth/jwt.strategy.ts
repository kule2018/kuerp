import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Admin } from '../system/entities/admin.entity';

/**
 * JWT 策略：解析并校验 token，挂载当前用户到 request.user。
 */
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(
    config: ConfigService,
    @InjectRepository(Admin) private readonly adminRepo: Repository<Admin>,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get<string>('JWT_SECRET') || 'secret',
    });
  }

  async validate(payload: any) {
    if (!payload || !payload.sub) throw new UnauthorizedException('登录已过期');
    const user = await this.adminRepo.findOne({
      where: { id: payload.sub, deletetime: 0 } as any,
    });
    if (!user || user.status !== 1) throw new UnauthorizedException('账号不可用');
    return { id: user.id, username: user.username, nickname: user.nickname };
  }
}
