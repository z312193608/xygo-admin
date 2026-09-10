-- ============================================================
-- v1.5.0 会员登录日志状态注释对齐 —— MySQL 版
-- 写入侧一直是 0=失败 1=成功（与后台登录日志一致），仅注释/生成器字典写反。
-- 不改数据，只修正 COMMENT，避免以后再按错误字典生成页面。
-- ============================================================

ALTER TABLE `xy_member_login_log`
  MODIFY COLUMN `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0=失败 1=成功';

UPDATE `xy_sys_gen_codes_column`
SET `comment` = '状态：0=失败 1=成功'
WHERE `gen_id` = 37 AND `name` = 'status';
