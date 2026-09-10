-- ============================================================
-- v1.5.0 会员登录日志状态注释对齐 —— PostgreSQL 版
-- 写入侧一直是 0=失败 1=成功（与后台登录日志一致），仅注释/生成器字典写反。
-- 不改数据，只修正 COMMENT。
-- ============================================================

COMMENT ON COLUMN public.xy_member_login_log.status IS '状态：0=失败 1=成功';

UPDATE public.xy_sys_gen_codes_column
SET comment = '状态：0=失败 1=成功'
WHERE gen_id = 37 AND name = 'status';
