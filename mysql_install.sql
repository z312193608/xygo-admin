-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2026-02-13 12:34:53
-- 服务器版本： 8.0.12
-- PHP 版本： 7.3.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `xygonew`
--

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_chat_message`
--

CREATE TABLE `xy_admin_chat_message` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '消息ID',
  `session_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会话ID',
  `sender_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '发送者ID',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '消息类型:1=文字,2=图片,3=系统消息',
  `content` text NOT NULL COMMENT '消息内容(图片时存URL)',
  `created_at` int(11) NOT NULL DEFAULT '0' COMMENT '发送时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='聊天消息表';

--
-- 转存表中的数据 `xy_admin_chat_message`
--

INSERT INTO `xy_admin_chat_message` (`id`, `session_id`, `sender_id`, `type`, `content`, `created_at`) VALUES
(1, 1, 2, 1, '你好', 1770709004),
(2, 1, 2, 1, '我是李小龙', 1770709123),
(3, 1, 2, 1, '你试试', 1770709436),
(4, 1, 2, 1, '自己当时发完自己看不到 的重新打卡才能看到', 1770709475),
(5, 1, 2, 1, '怎么是', 1770709490),
(6, 1, 2, 1, '你是谁啊', 1770709696),
(7, 1, 2, 1, '我是校长', 1770709712),
(8, 1, 2, 1, '你可以看到我们', 1770709778),
(9, 1, 2, 1, '你是谁', 1770710049),
(10, 1, 2, 1, '我是我', 1770710211),
(11, 1, 2, 1, '我也可能是你', 1770710222),
(12, 1, 2, 1, '你不是我', 1770710429),
(13, 1, 2, 1, '你说话啊', 1770710619),
(14, 1, 2, 1, '我来了', 1770710634),
(15, 1, 1, 1, 'haode', 1770710640),
(16, 1, 1, 2, '/attachment/upload/20260210/b17249d2-0d9d-496d-a6a5-1c9c2c603459.webp', 1770710651),
(17, 4, 0, 3, 'admin2 创建了群聊', 1770711683),
(18, 4, 2, 1, 'hellow', 1770711690),
(19, 4, 1, 1, 'laile', 1770711703),
(20, 1, 1, 1, '我呢', 1770738262),
(21, 1, 1, 1, '这是我', 1770738530),
(22, 1, 1, 1, '你是谁', 1770796950),
(23, 1, 2, 1, '我是你的人', 1770796994);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_chat_session`
--

CREATE TABLE `xy_admin_chat_session` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '会话ID',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型:1=单聊,2=群聊',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '群名称(单聊为空)',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '群头像',
  `creator_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建者ID',
  `last_message` varchar(500) NOT NULL DEFAULT '' COMMENT '最后消息预览',
  `last_message_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后消息时间戳',
  `member_count` int(11) NOT NULL DEFAULT '0' COMMENT '成员数',
  `created_at` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='聊天会话表';

--
-- 转存表中的数据 `xy_admin_chat_session`
--

INSERT INTO `xy_admin_chat_session` (`id`, `type`, `name`, `avatar`, `creator_id`, `last_message`, `last_message_time`, `member_count`, `created_at`, `updated_at`) VALUES
(1, 1, '', '', 2, '我是你的人', 1770796994, 2, 1770708990, 1770796994),
(2, 1, '', '', 2, '', 1770711417, 2, 1770711417, 1770711417),
(3, 1, '', '', 2, '', 1770711657, 2, 1770711657, 1770711657),
(4, 2, 'testgroup', '', 2, 'laile', 1770711703, 4, 1770711683, 1770711703);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_chat_session_member`
--

CREATE TABLE `xy_admin_chat_session_member` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键',
  `session_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会话ID',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '用户ID',
  `role` tinyint(4) NOT NULL DEFAULT '1' COMMENT '角色:1=成员,2=管理员,3=群主',
  `unread_count` int(11) NOT NULL DEFAULT '0' COMMENT '未读消息数',
  `last_read_msg_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '最后已读消息ID',
  `is_muted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否免打扰:0=否,1=是',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除会话:0=否,1=是',
  `joined_at` int(11) NOT NULL DEFAULT '0' COMMENT '加入时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='聊天会话成员表';

--
-- 转存表中的数据 `xy_admin_chat_session_member`
--

INSERT INTO `xy_admin_chat_session_member` (`id`, `session_id`, `user_id`, `role`, `unread_count`, `last_read_msg_id`, `is_muted`, `is_deleted`, `joined_at`) VALUES
(1, 1, 1, 1, 0, 23, 0, 0, 1770708990),
(2, 1, 2, 1, 0, 22, 0, 0, 1770708990),
(3, 2, 3, 1, 0, 0, 0, 0, 1770711417),
(4, 2, 2, 1, 0, 0, 0, 0, 1770711417),
(5, 3, 4, 1, 0, 0, 0, 0, 1770711657),
(6, 3, 2, 1, 0, 0, 0, 0, 1770711657),
(7, 4, 1, 1, 0, 19, 0, 0, 1770711683),
(8, 4, 3, 1, 2, 0, 0, 0, 1770711683),
(9, 4, 4, 1, 2, 0, 0, 0, 1770711683),
(10, 4, 2, 3, 0, 19, 0, 0, 1770711683);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_dept`
--

CREATE TABLE `xy_admin_dept` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '部门ID',
  `parent_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '上级部门ID',
  `name` varchar(50) NOT NULL COMMENT '部门名称',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态:0禁用,1启用',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_by` bigint(20) UNSIGNED DEFAULT '0' COMMENT '创建人',
  `create_time` int(10) UNSIGNED DEFAULT NULL COMMENT '创建时间',
  `update_time` int(10) UNSIGNED DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门管理';

--
-- 转存表中的数据 `xy_admin_dept`
--

INSERT INTO `xy_admin_dept` (`id`, `parent_id`, `name`, `sort`, `status`, `remark`, `create_by`, `create_time`, `update_time`) VALUES
(1, 0, '总公司', 1, 1, '顶级部门', 0, 1768570149, 1768570149),
(2, 1, '技术部', 1, 1, '负责技术开发', 0, 1768570149, 1768570149),
(3, 1, '市场部', 2, 1, '负责市场推广', 0, 1768570149, 1768570149),
(4, 1, '财务部', 3, 1, '负责财务管理', 0, 1768570149, 1768570149),
(5, 2, '前端组', 1, 1, '前端开发团队', 0, 1768570149, 1768570149),
(6, 2, '后端组', 2, 1, '后端开发团队', 0, 1768570149, 1768570149),
(7, 3, '线上推广组', 1, 1, '负责线上营销', 0, 1768570149, 1768570149),
(8, 3, '线下推广组', 2, 1, '负责线下活动', 0, 1768570149, 1768570149);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_dept_closure`
--

CREATE TABLE `xy_admin_dept_closure` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID',
  `ancestor` bigint(20) UNSIGNED NOT NULL COMMENT '祖先部门ID',
  `descendant` bigint(20) UNSIGNED NOT NULL COMMENT '后代部门ID',
  `level` int(11) NOT NULL DEFAULT '0' COMMENT '层级深度'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门闭包表';

--
-- 转存表中的数据 `xy_admin_dept_closure`
--

INSERT INTO `xy_admin_dept_closure` (`id`, `ancestor`, `descendant`, `level`) VALUES
(1, 1, 1, 0),
(2, 1, 2, 1),
(3, 2, 2, 0),
(4, 1, 3, 1),
(5, 3, 3, 0),
(6, 1, 4, 1),
(7, 4, 4, 0),
(8, 1, 5, 2),
(9, 2, 5, 1),
(10, 5, 5, 0),
(11, 1, 6, 2),
(12, 2, 6, 1),
(13, 6, 6, 0),
(14, 1, 7, 2),
(15, 3, 7, 1),
(16, 7, 7, 0),
(17, 1, 8, 2),
(18, 3, 8, 1),
(19, 8, 8, 0);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_field_perm`
--

CREATE TABLE `xy_admin_field_perm` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键',
  `role_id` bigint(20) UNSIGNED NOT NULL COMMENT '角色ID',
  `module` varchar(50) NOT NULL DEFAULT '' COMMENT '模块名称（如：system、org）',
  `resource` varchar(100) NOT NULL COMMENT '资源标识（表名或页面标识，如：admin_user、user_list）',
  `field_name` varchar(100) NOT NULL COMMENT '字段名称（如：mobile、salary）',
  `field_label` varchar(100) DEFAULT NULL COMMENT '字段显示名称（用于界面展示）',
  `perm_type` tinyint(4) NOT NULL DEFAULT '2' COMMENT '权限类型：0=不可见，1=只读，2=可编辑',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0=禁用，1=启用',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` int(10) UNSIGNED NOT NULL COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字段权限配置表';

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_login_log`
--

CREATE TABLE `xy_admin_login_log` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '日志ID',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '管理员ID（0=未知用户）',
  `username` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '登录账号',
  `ip` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '登录IP',
  `location` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '登录地点',
  `user_agent` varchar(500) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `browser` varchar(128) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '浏览器',
  `os` varchar(128) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作系统',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0=失败 1=成功',
  `message` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '提示消息',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='管理员登录日志';

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_menu`
--

CREATE TABLE `xy_admin_menu` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '菜单ID',
  `parent_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '上级菜单ID',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '类型:1=目录,2=菜单,3=按钮',
  `title` varchar(50) NOT NULL COMMENT '标题(菜单名称)',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '前端路由name',
  `path` varchar(100) NOT NULL DEFAULT '' COMMENT '路由路径',
  `component` varchar(100) NOT NULL DEFAULT '' COMMENT '前端组件路径',
  `resource` varchar(50) DEFAULT '' COMMENT '关联的数据资源（表名，用于字段权限）',
  `icon` varchar(50) NOT NULL DEFAULT '' COMMENT '图标',
  `hidden` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否隐藏:0=否,1=是',
  `keep_alive` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否缓存:0=否,1=是',
  `redirect` varchar(100) NOT NULL DEFAULT '' COMMENT '重定向地址',
  `frame_src` varchar(255) NOT NULL DEFAULT '' COMMENT '内嵌iframe地址',
  `perms` text COMMENT '权限点列表(JSON数组,内容为 METHOD+PATH 字符串)',
  `is_frame` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否内嵌:0=否,1=是',
  `affix` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否固定标签:0=否,1=是',
  `show_badge` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否显示徽章:0=否,1=是',
  `badge_text` varchar(50) NOT NULL DEFAULT '' COMMENT '徽章文本',
  `active_path` varchar(255) NOT NULL DEFAULT '' COMMENT '激活高亮路径',
  `hide_tab` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否隐藏标签:0=否,1=是',
  `is_full_page` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否全屏页面:0=否,1=是',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序(越大越靠后)',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `created_by` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `updated_by` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='后台菜单/权限表';

--
-- 转存表中的数据 `xy_admin_menu`
--

INSERT INTO `xy_admin_menu` (`id`, `parent_id`, `type`, `title`, `name`, `path`, `component`, `resource`, `icon`, `hidden`, `keep_alive`, `redirect`, `frame_src`, `perms`, `is_frame`, `affix`, `show_badge`, `badge_text`, `active_path`, `hide_tab`, `is_full_page`, `sort`, `status`, `remark`, `created_by`, `updated_by`, `create_time`, `update_time`) VALUES
(1, 0, 1, '仪表盘', 'Dashboard', '/dashboard', '/index/index', '', 'ri:pie-chart-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 10, 1, '仪表盘根', 0, 0, 1768549363, 1768549363),
(2, 1, 2, '工作台', 'Console', 'console', '/dashboard/console', '', 'ri:home-smile-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 11, 1, '仪表盘-工作台', 0, 0, 1768549363, 1768549363),
(3, 1, 2, '分析页', 'Analysis', 'analysis', '/dashboard/analysis', '', 'ri:align-item-bottom-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 12, 1, '仪表盘-分析', 0, 0, 1768549363, 1768549363),
(4, 1, 2, '电商页', 'Ecommerce', 'ecommerce', '/dashboard/ecommerce', '', 'ri:bar-chart-box-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 13, 1, '仪表盘-电商', 0, 0, 1768549363, 1768549363),
(10, 0, 1, '模板中心', 'Template', '/template', '/index/index', '', 'ri:apps-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 20, 1, '模板根', 0, 0, 1768549363, 1768549363),
(11, 10, 2, '卡片', 'Cards', 'cards', '/template/cards', '', 'ri:wallet-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 21, 1, '模板-卡片', 0, 0, 1768549363, 1768549363),
(12, 10, 2, '横幅', 'Banners', 'banners', '/template/banners', '', 'ri:rectangle-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 22, 1, '模板-横幅', 0, 0, 1768549363, 1768549363),
(13, 10, 2, '图表', 'Charts', 'charts', '/template/charts', '', 'ri:bar-chart-box-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 23, 1, '模板-图表', 0, 0, 1768549363, 1768549363),
(14, 10, 2, '地图', 'Map', 'map', '/template/map', '', 'ri:map-pin-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 24, 1, '模板-地图', 0, 0, 1768549363, 1768549363),
(15, 10, 2, '聊天', 'Chat', 'chat', '/template/chat', '', 'ri:message-3-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 25, 1, '模板-聊天', 0, 0, 1768549363, 1768549363),
(16, 10, 2, '日历', 'Calendar', 'calendar', '/template/calendar', '', 'ri:calendar-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 26, 1, '模板-日历', 0, 0, 1768549363, 1768549363),
(17, 10, 2, '定价', 'Pricing', 'pricing', '/template/pricing', '', 'ri:money-cny-box-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 27, 1, '模板-定价', 0, 0, 1768549363, 1768549363),
(20, 0, 2, '组件中心', 'Widgets', '/widgets', '/index/index', '', 'ri:apps-2-add-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 30, 1, '', 0, 0, 1768549363, 1768549363),
(21, 20, 2, '图标', 'Icon', 'icon', '/widgets/icon', '', 'ri:palette-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 31, 1, '组件-图标', 0, 0, 1768549363, 1768549363),
(22, 20, 2, '图片裁剪', 'ImageCrop', 'image-crop', '/widgets/image-crop', '', 'ri:screenshot-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 32, 1, '组件-裁剪', 0, 0, 1768549363, 1768549363),
(23, 20, 2, 'Excel', 'Excel', 'excel', '/widgets/excel', '', 'ri:download-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 33, 1, '组件-Excel', 0, 0, 1768549363, 1768549363),
(24, 20, 2, '视频', 'Video', 'video', '/widgets/video', '', 'ri:vidicon-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 34, 1, '组件-视频', 0, 0, 1768549363, 1768549363),
(25, 20, 2, 'CountTo', 'CountTo', 'count-to', '/widgets/count-to', '', 'ri:anthropic-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 35, 1, '组件-CountTo', 0, 0, 1768549363, 1768549363),
(26, 20, 2, '富文本', 'WangEditor', 'wang-editor', '/widgets/wang-editor', '', 'ri:t-box-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 36, 1, '组件-富文本', 0, 0, 1768549363, 1768549363),
(27, 20, 2, '水印', 'Watermark', 'watermark', '/widgets/watermark', '', 'ri:water-flash-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 37, 1, '组件-水印', 0, 0, 1768549363, 1768549363),
(28, 20, 2, '右键菜单', 'ContextMenu', 'context-menu', '/widgets/context-menu', '', 'ri:menu-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 38, 1, '组件-右键', 0, 0, 1768549363, 1768549363),
(29, 20, 2, '二维码', 'Qrcode', 'qrcode', '/widgets/qrcode', '', 'ri:qr-code-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 39, 1, '组件-二维码', 0, 0, 1768549363, 1768549363),
(30, 20, 2, '拖拽', 'Drag', 'drag', '/widgets/drag', '', 'ri:drag-move-fill', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 40, 1, '组件-拖拽', 0, 0, 1768549363, 1768549363),
(31, 20, 2, '文字滚动', 'TextScroll', 'text-scroll', '/widgets/text-scroll', '', 'ri:input-method-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 41, 1, '组件-文字滚动', 0, 0, 1768549363, 1768549363),
(32, 20, 2, '烟花', 'Fireworks', 'fireworks', '/widgets/fireworks', '', 'ri:magic-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 42, 1, '组件-烟花', 0, 0, 1768549363, 1768549363),
(33, 20, 2, '外链-ElementUI', 'ElementUI', 'elementui', '', '', 'ri:apps-2-line', 0, 0, '', 'https://element-plus.org/zh-CN/component/overview.html', '', 1, 0, 0, '', '', 0, 0, 43, 1, '组件-外链', 0, 0, 1768549363, 1768549363),
(40, 0, 1, '功能示例', 'Examples', '/examples', '/index/index', '', 'ri:sparkling-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 50, 1, '示例根', 0, 0, 1768549363, 1768549363),
(41, 40, 1, '权限示例', 'Permission', 'permission', '', '', 'ri:fingerprint-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 51, 1, '示例-权限', 0, 0, 1768549363, 1768549363),
(42, 41, 2, '切换角色', 'PermissionSwitchRole', 'switch-role', '/examples/permission/switch-role', '', 'ri:contacts-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 52, 1, '权限-切换角色', 0, 0, 1768549363, 1768549363),
(43, 41, 2, '按钮权限', 'PermissionButtonAuth', 'button-auth', '/examples/permission/button-auth', '', 'ri:mouse-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 53, 1, '权限-按钮', 0, 0, 1768549363, 1768549363),
(44, 41, 2, '页面可见性', 'PermissionPageVisibility', 'page-visibility', '/examples/permission/page-visibility', '', 'ri:user-3-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 54, 1, '权限-可见性', 0, 0, 1768549363, 1768549363),
(45, 40, 2, '多标签页', 'Tabs', 'tabs', '/examples/tabs', '', 'ri:price-tag-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 55, 1, '示例-标签', 0, 0, 1768549363, 1768549363),
(46, 40, 2, '表格基础', 'TablesBasic', 'tables-basic', '/examples/tables/basic', '', 'ri:layout-grid-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 56, 1, '示例-表格基础', 0, 0, 1768549363, 1768549363),
(47, 40, 2, '表格综合', 'Tables', 'tables', '/examples/tables', '', 'ri:table-3', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 57, 1, '示例-表格综合', 0, 0, 1768549363, 1768549363),
(48, 40, 2, '表单综合', 'Forms', 'forms', '/examples/forms', '', 'ri:table-view', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 58, 1, '示例-表单', 0, 0, 1768549363, 1768549363),
(49, 40, 2, '搜索栏', 'SearchBar', 'search-bar', '/examples/forms/search-bar', '', 'ri:table-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 59, 1, '示例-搜索栏', 0, 0, 1768549363, 1768549363),
(50, 40, 2, '树表格', 'TablesTree', 'tables-tree', '/examples/tables/tree', '', 'ri:layout-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 60, 1, '示例-树表', 0, 0, 1768549363, 1768549363),
(51, 40, 2, 'Socket 聊天', 'SocketChat', 'socket-chat', '/examples/socket-chat', '', 'ri:shake-hands-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 61, 1, '示例-聊天', 0, 0, 1768549363, 1768549363),
(60, 0, 1, '系统管理', 'System', '/system', '/index/index', '', 'ri:settings-3-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 70, 1, '系统设置和配置', 0, 0, 1768549363, 1768549363),
(61, 140, 2, '后台用户', 'User', 'user', '/system/user', 'admin_user', 'ri:user-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 3, 1, '后台用户管理', 0, 0, 1768549363, 1768549363),
(62, 140, 2, '角色管理', 'Role', 'role', '/system/role', 'admin_role', 'ri:user-settings-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 4, 1, '角色权限管理', 0, 0, 1768549363, 1768549363),
(63, 60, 2, '用户中心', 'UserCenter', 'user-center', '/system/user-center', '', 'ri:user-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 1, 1, '系统-用户中心', 0, 0, 1768549363, 1768549363),
(64, 140, 2, '菜单管理', 'Menus', 'menu', '/system/menu', 'admin_menu', 'ri:menu-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 5, 1, '菜单权限管理', 0, 0, 1768549363, 1768549363),
(65, 60, 2, '系统设置', 'SystemConfig', 'config', '/system/config', 'sys_config', 'ri:settings-3-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 2, 1, '', 0, 0, 1768549363, 1768549363),
(66, 60, 1, '多级菜单', 'Nested', 'nested', '', '', 'ri:menu-unfold-3-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 10, 1, '系统-嵌套', 0, 0, 1768549363, 1768549363),
(67, 66, 2, '菜单1', 'NestedMenu1', 'menu1', '/system/nested/menu1', '', 'ri:align-justify', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 77, 1, '嵌套-1', 0, 0, 1768549363, 1768549363),
(68, 66, 1, '菜单2', 'NestedMenu2', 'menu2', '', '', 'ri:align-justify', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 78, 1, '嵌套-2', 0, 0, 1768549363, 1768549363),
(69, 68, 2, '菜单2-1', 'NestedMenu2-1', 'menu2-1', '/system/nested/menu2', '', 'ri:align-justify', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 79, 1, '嵌套-2-1', 0, 0, 1768549363, 1768549363),
(70, 66, 1, '菜单3', 'NestedMenu3', 'menu3', '', '', 'ri:align-justify', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 80, 1, '嵌套-3', 0, 0, 1768549363, 1768549363),
(71, 70, 2, '菜单3-1', 'NestedMenu3-1', 'menu3-1', '/system/nested/menu3', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 81, 1, '嵌套-3-1', 0, 0, 1768549363, 1768549363),
(72, 70, 1, '菜单3-2', 'NestedMenu3-2', 'menu3-2', '', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 82, 1, '嵌套-3-2', 0, 0, 1768549363, 1768549363),
(73, 72, 2, '菜单3-2-1', 'NestedMenu3-2-1', 'menu3-2-1', '/system/nested/menu3/menu3-2', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 83, 1, '嵌套-3-2-1', 0, 0, 1768549363, 1768549363),
(80, 0, 1, '内容管理', 'Cms', '/cms', '/index/index', '', 'ri:article-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 85, 1, '内容管理根', 0, 0, 1768549363, 1768549363),
(81, 80, 2, '文档分类', 'CmsDocCategory', 'doc-category', '/cms/doc-category', '', 'ri:folder-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 1, 1, '文档分类管理', 0, 0, 1768549363, 1768549363),
(82, 80, 2, '文档管理', 'CmsDoc', 'doc', '/cms/doc', '', 'ri:file-text-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 2, 1, '文档内容管理', 0, 0, 1768549363, 1768549363),
(83, 82, 3, '新增/编辑', 'CmsDocSave', '', '', '', '', 0, 0, '', '', '/admin/cms/doc/save', 0, 0, 0, '', '', 0, 0, 1, 1, '新增或编辑文档', 0, 0, 1768549363, 1768549363),
(84, 82, 3, '删除', 'CmsDocDelete', '', '', '', '', 0, 0, '', '', '/admin/cms/doc/delete', 0, 0, 0, '', '', 0, 0, 2, 1, '删除文档', 0, 0, 1768549363, 1768549363),
(85, 81, 3, '新增/编辑', 'CmsDocCategorySave', '', '', '', '', 0, 0, '', '', '/admin/cms/docCategory/save', 0, 0, 0, '', '', 0, 0, 1, 1, '新增或编辑分类', 0, 0, 1768549363, 1768549363),
(86, 81, 3, '删除', 'CmsDocCategoryDelete', '', '', '', '', 0, 0, '', '', '/admin/cms/docCategory/delete', 0, 0, 0, '', '', 0, 0, 2, 1, '删除分类', 0, 0, 1768549363, 1768549363),
(90, 0, 1, '结果页', 'Result', '/result', '/index/index', '', 'ri:checkbox-circle-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 100, 1, '结果根', 0, 0, 1768549363, 1768549363),
(91, 90, 2, '成功页', 'ResultSuccess', 'success', '/result/success', '', 'ri:checkbox-circle-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 101, 1, '结果-成功', 0, 0, 1768549363, 1768549363),
(92, 90, 2, '失败页', 'ResultFail', 'fail', '/result/fail', '', 'ri:close-circle-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 102, 1, '结果-失败', 0, 0, 1768549363, 1768549363),
(100, 0, 1, '异常页', 'Exception', '/exception', '/index/index', '', 'ri:error-warning-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 110, 1, '异常根', 0, 0, 1768549363, 1768549363),
(101, 100, 2, '403', 'Exception403', '403', '/exception/403', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 111, 1, '异常-403', 0, 0, 1768549363, 1768549363),
(102, 100, 2, '404', 'Exception404', '404', '/exception/404', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 112, 1, '异常-404', 0, 0, 1768549363, 1768549363),
(103, 100, 2, '500', 'Exception500', '500', '/exception/500', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 113, 1, '异常-500', 0, 0, 1768549363, 1768549363),
(110, 0, 1, '运维管理', 'Safeguard', '/safeguard', '/index/index', '', 'ri:shield-check-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 120, 1, '运维根', 0, 0, 1768549363, 1768549363),
(111, 110, 2, '服务器监控', 'SafeguardServer', 'server', '/safeguard/server', '', 'ri:hard-drive-3-line', 0, 1, '', '', '[\"GET /admin/monitor/server\"]', 0, 0, 0, '', '', 0, 0, 121, 1, '运维-服务器', 0, 0, 1768549363, 1770644180),
(122, 60, 2, '附件管理', 'system/attachment', 'system/attachment', '/system/attachment/index', 'sys_attachment', 'ep:folder-opened', 0, 1, '', '', NULL, 0, 0, 0, '', '', 0, 0, 3, 1, '附件中心与文件管理', 0, 0, 1768549363, 1768549363),
(123, 122, 3, '查看', 'system/attachment/index', '', '', '', '', 0, 0, '', '', 'system:attachment:list', 0, 0, 0, '', '', 0, 0, 1, 1, '', 0, 0, 1768549363, 1768549363),
(124, 122, 3, '编辑', 'system/attachment/edit', '', '', '', '', 0, 0, '', '', 'system:attachment:edit', 0, 0, 0, '', '', 0, 0, 2, 1, '', 0, 0, 1768549363, 1768549363),
(125, 122, 3, '删除', 'system/attachment/del', '', '', '', '', 0, 0, '', '', 'system:attachment:del', 0, 0, 0, '', '', 0, 0, 3, 1, '', 0, 0, 1768549363, 1768549363),
(126, 20, 2, '图标选择器', 'IconSelector', 'icon-selector', '/widgets/icon-selector', '', 'ri:palette-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 33, 1, '图标选择器组件', 0, 0, 1768549363, 1768549363),
(127, 20, 2, '颜色选择器', 'ColorPicker', 'color-picker', '/widgets/color-picker', '', 'ri:palette-fill', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 34, 1, '颜色选择器组件', 0, 0, 1768549363, 1768549363),
(128, 20, 2, '图片上传', 'ImageUpload', 'image-upload', '/widgets/image-upload', '', 'ri:image-2-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 35, 1, '图片上传组件', 0, 0, 1768549363, 1768549363),
(129, 20, 2, '文件上传', 'FileUpload', 'file-upload', '/widgets/file-upload', '', 'ri:file-upload-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 36, 1, '文件上传组件', 0, 0, 1768549363, 1768549363),
(130, 20, 2, '数组编辑器', 'ArrayEditor', 'array-editor', '/widgets/array-editor', '', 'ri:list-settings-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 37, 1, '多维数组编辑器组件', 0, 0, 1768549363, 1768549363),
(140, 0, 1, '权限管理', 'Auth', '/auth', '/index/index', '', 'ri:admin-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 65, 1, '权限管理模块', 0, 0, 1768549363, 1768549363),
(141, 140, 2, '部门管理', 'Dept', 'dept', '/system/dept', 'admin_dept', 'ri:organization-chart', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 1, 1, '组织架构和部门管理', 0, 0, 1768549363, 1768549363),
(142, 140, 2, '岗位管理', 'Post', 'post', '/system/post', 'admin_post', 'ri:briefcase-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 2, 1, '岗位管理（职位字典）', 0, 0, 1768549363, 1768549363),
(143, 0, 1, '会员管理', 'Member', '/member', '', '', 'ri:user-star-line', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 50, 1, '', 0, 0, 1768748969, 1768748969),
(144, 143, 2, '会员列表', 'MemberList', 'list', '/member/list/index', '', 'ri:team-line', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 10, 1, '', 0, 0, 1768748969, 1768748969),
(145, 143, 3, '添加会员', 'MemberAdd', '', '', '', '', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 1, 1, '', 0, 0, 1768748969, 1768748969),
(146, 143, 3, '编辑会员', 'MemberEdit', '', '', '', '', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 2, 1, '', 0, 0, 1768748969, 1768748969),
(147, 143, 3, '删除会员', 'MemberDelete', '', '', '', '', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 3, 1, '', 0, 0, 1768748969, 1768748969),
(148, 143, 3, '重置密码', 'MemberResetPassword', '', '', '', '', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 4, 1, '', 0, 0, 1768748969, 1768748969),
(149, 143, 2, '会员分组', 'MemberGroup', 'group', '/member/group/index', 'member_group', 'ri:group-line', 0, 1, '', '', '[\"POST /admin/member/group/list\"]', 0, 0, 0, '', '', 0, 0, 20, 1, '会员分组管理', 0, 0, 1768791091, 1768791091),
(150, 149, 3, '新增分组', 'MemberGroupAdd', '', '', 'member_group', '', 0, 0, '', '', '[\"POST /admin/member/group/save\"]', 0, 0, 0, '', '', 0, 0, 1, 1, '新增会员分组', 0, 0, 1768791091, 1768791091),
(151, 149, 3, '编辑分组', 'MemberGroupEdit', '', '', 'member_group', '', 0, 0, '', '', '[\"POST /admin/member/group/save\"]', 0, 0, 0, '', '', 0, 0, 2, 1, '编辑会员分组', 0, 0, 1768791091, 1768791091),
(152, 149, 3, '删除分组', 'MemberGroupDelete', '', '', 'member_group', '', 0, 0, '', '', '[\"POST /admin/member/group/delete\"]', 0, 0, 0, '', '', 0, 0, 3, 1, '删除会员分组', 0, 0, 1768791091, 1768791091),
(153, 143, 2, '会员菜单', 'MemberMenu', 'menu', '/member/menu/index', 'member_menu', 'ri:menu-line', 0, 1, '', '', '[\"GET /admin/member/menu/tree\"]', 0, 0, 0, '', '', 0, 0, 30, 1, '会员前台菜单管理', 0, 0, 1768791091, 1768791091),
(154, 153, 3, '新增菜单', 'MemberMenuAdd', '', '', 'member_menu', '', 0, 0, '', '', '[\"POST /admin/member/menu/save\"]', 0, 0, 0, '', '', 0, 0, 1, 1, '新增会员菜单', 0, 0, 1768791091, 1768791091),
(155, 153, 3, '编辑菜单', 'MemberMenuEdit', '', '', 'member_menu', '', 0, 0, '', '', '[\"POST /admin/member/menu/save\"]', 0, 0, 0, '', '', 0, 0, 2, 1, '编辑会员菜单', 0, 0, 1768791091, 1768791091),
(156, 153, 3, '删除菜单', 'MemberMenuDelete', '', '', 'member_menu', '', 0, 0, '', '', '[\"POST /admin/member/menu/delete\"]', 0, 0, 0, '', '', 0, 0, 3, 1, '删除会员菜单', 0, 0, 1768791091, 1768791091),
(157, 110, 2, '登录日志', 'LoginLog', 'login-log', '/safeguard/login-log', 'admin_login_log', 'ri:login-box-line', 0, 1, '', '', '[\"POST /admin/log/login/list\"]', 0, 0, 0, '', '', 0, 0, 122, 1, '管理员登录日志', 0, 0, 1770615724, 1770615724),
(158, 157, 3, '删除日志', 'LoginLogDelete', '', '', 'admin_login_log', '', 0, 0, '', '', '[\"POST /admin/log/login/delete\"]', 0, 0, 0, '', '', 0, 0, 1, 1, '删除登录日志', 0, 0, 1770615724, 1770615724),
(159, 157, 3, '清空日志', 'LoginLogClear', '', '', 'admin_login_log', '', 0, 0, '', '', '[\"POST /admin/log/login/clear\"]', 0, 0, 0, '', '', 0, 0, 2, 1, '清空登录日志', 0, 0, 1770615724, 1770615724),
(160, 110, 2, '操作日志', 'OperationLog', 'operation-log', '/safeguard/operation-log', 'admin_operation_log', 'ri:file-text-line', 0, 1, '', '', '[\"POST /admin/log/operation/list\"]', 0, 0, 0, '', '', 0, 0, 123, 1, '管理员操作日志', 0, 0, 1770615724, 1770615724),
(161, 160, 3, '查看详情', 'OperationLogDetail', '', '', 'admin_operation_log', '', 0, 0, '', '', '[\"GET /admin/log/operation/detail\"]', 0, 0, 0, '', '', 0, 0, 1, 1, '查看操作日志详情', 0, 0, 1770615724, 1770615724),
(162, 160, 3, '删除日志', 'OperationLogDelete', '', '', 'admin_operation_log', '', 0, 0, '', '', '[\"POST /admin/log/operation/delete\"]', 0, 0, 0, '', '', 0, 0, 2, 1, '删除操作日志', 0, 0, 1770615724, 1770615724),
(163, 160, 3, '清空日志', 'OperationLogClear', '', '', 'admin_operation_log', '', 0, 0, '', '', '[\"POST /admin/log/operation/clear\"]', 0, 0, 0, '', '', 0, 0, 3, 1, '清空操作日志', 0, 0, 1770615724, 1770615724),
(164, 110, 2, '性能分析', 'SafeguardPerformance', 'performance', '/safeguard/performance', 'admin_operation_log', 'ri:line-chart-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 124, 1, '', 0, 0, 1770644179, 1770644179),
(165, 0, 1, '开发工具', 'Develop', '/develop', '/index/index', '', 'ri:code-box-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 125, 1, '开发工具目录', 0, 0, 1770648637, 1770648637),
(166, 165, 2, '代码生成器', 'GenCodes', 'gen-codes', '/develop/gen-codes/index', 'sys_gen_codes', 'ri:magic-line', 0, 1, '', '', '[\"GET /admin/genCodes/selects\",\"GET /admin/genCodes/tableSelect\",\"GET /admin/genCodes/columnList\",\"GET /admin/genCodes/list\",\"GET /admin/genCodes/view\",\"POST /admin/genCodes/edit\",\"POST /admin/genCodes/delete\",\"POST /admin/genCodes/preview\",\"POST /admin/genCodes/build\",\"POST /admin/genCodes/createTable\"]', 0, 0, 0, '', '', 0, 0, 1, 1, '代码生成器', 0, 0, 1770648637, 1770648637),
(202, 110, 2, '函数分析', 'PprofAnalysis', 'pprof', '/safeguard/pprof/index', '', 'ri:code-s-slash-line', 0, 1, '', '', '[\"GET /admin/monitor/pprof-top\"]', 0, 0, 0, '', '', 0, 0, 125, 1, '函数级CPU/内存热点分析(pprof)', 0, 0, 1770702712, 1770702712),
(220, 60, 2, '通知管理', 'Notice', 'notice', '/system/notice/index', 'admin_notice', 'ri:notification-3-line', 0, 1, '', '', '[\"POST /admin/notice/list\"]', 0, 0, 0, '', '', 0, 0, 4, 1, '通知消息管理', 0, 0, 1770700000, 1770700000),
(221, 220, 3, '查看', 'NoticeView', '', '', 'admin_notice', '', 0, 0, '', '', '[\"POST /admin/notice/list\"]', 0, 0, 0, '', '', 0, 0, 1, 1, '查看通知列表', 0, 0, 1770700000, 1770700000),
(222, 220, 3, '发布/编辑', 'NoticeEdit', '', '', 'admin_notice', '', 0, 0, '', '', '[\"POST /admin/notice/edit\"]', 0, 0, 0, '', '', 0, 0, 2, 1, '发布或编辑通知', 0, 0, 1770700000, 1770700000),
(223, 220, 3, '删除', 'NoticeDelete', '', '', 'admin_notice', '', 0, 0, '', '', '[\"POST /admin/notice/delete\"]', 0, 0, 0, '', '', 0, 0, 3, 1, '删除通知', 0, 0, 1770700000, 1770700000),
(240, 60, 2, '定时任务', 'CronManage', 'cron', '/system/cron/index', 'sys_cron', 'ri:timer-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 80, 1, '定时任务管理', 0, 0, 1770717535, 1770717535),
(241, 240, 3, '查看', 'CronView', '', '', '', '', 0, 0, '', '', 'GET /admin/cron/list', 0, 0, 0, '', '', 0, 0, 0, 1, '', 0, 0, 1770717535, 1770717535),
(242, 240, 3, '新增/编辑', 'CronEdit', '', '', '', '', 0, 0, '', '', 'POST /admin/cron/save', 0, 0, 0, '', '', 0, 0, 0, 1, '', 0, 0, 1770717535, 1770717535),
(243, 240, 3, '删除', 'CronDelete', '', '', '', '', 0, 0, '', '', 'POST /admin/cron/delete', 0, 0, 0, '', '', 0, 0, 0, 1, '', 0, 0, 1770717535, 1770717535),
(244, 240, 3, '在线执行', 'CronOnlineExec', '', '', '', '', 0, 0, '', '', 'POST /admin/cron/onlineExec', 0, 0, 0, '', '', 0, 0, 0, 1, '', 0, 0, 1770717535, 1770717535),
(250, 60, 2, '消息队列', 'QueueManage', 'queue', '/system/queue/index', '', 'ri:stack-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 85, 1, '消息队列管理', 0, 0, 1770719034, 1770719034),
(418, 143, 2, '登录日志', 'MemberLoginLog', 'member-login-log', '/member/member-login-log/index', '', 'ri:file-list-line', 0, 1, '', '', '[\"GET /admin/member-login-log/list\"]', 0, 0, 0, '', '', 0, 0, 100, 1, '', 0, 0, 1770873777, 1770873777),
(419, 418, 3, '查看登录日志', 'MemberLoginLogView', '', '', '', '', 0, 0, '', '', '[\"GET /admin/member-login-log/view\"]', 0, 0, 0, '', '', 0, 0, 1, 1, '', 0, 0, 1770873777, 1770873777),
(420, 143, 2, '登录日志详情', 'MemberLoginLogDetail', 'member-login-log/detail', '/member/member-login-log/detail/index', '', '', 1, 0, '', '', '[\"GET /admin/member-login-log/view\"]', 0, 0, 0, '', '/member-login-log', 0, 0, 0, 1, '', 0, 0, 1770873777, 1770873777),
(421, 418, 3, '删除登录日志', 'MemberLoginLogDelete', '', '', '', '', 0, 0, '', '', '[\"POST /admin/member-login-log/delete\"]', 0, 0, 0, '', '', 0, 0, 4, 1, '', 0, 0, 1770873777, 1770873777),
(422, 418, 3, '导出登录日志', 'MemberLoginLogExport', '', '', '', '', 0, 0, '', '', '[\"GET /admin/member-login-log/export\"]', 0, 0, 0, '', '', 0, 0, 5, 1, '', 0, 0, 1770873777, 1770873777),
(511, 143, 2, '余额变动日志', 'MemberMoneyLog', 'member-money-log', '/member/member-money-log/index', '', 'ri:file-list-line', 0, 1, '', '', '[\"GET /admin/member-money-log/list\"]', 0, 0, 0, '', '', 0, 0, 100, 1, '', 0, 0, 1770881561, 1770881561),
(512, 511, 3, '查看余额变动日志', 'MemberMoneyLogView', '', '', '', '', 0, 0, '', '', '[\"GET /admin/member-money-log/view\"]', 0, 0, 0, '', '', 0, 0, 1, 1, '', 0, 0, 1770881561, 1770881561),
(513, 511, 3, '新增余额变动日志', 'MemberMoneyLogAdd', '', '', '', '', 0, 0, '', '', '[\"POST /admin/member-money-log/edit\"]', 0, 0, 0, '', '', 0, 0, 2, 1, '', 0, 0, 1770881561, 1770881561),
(514, 511, 3, '编辑余额变动日志', 'MemberMoneyLogEdit', '', '', '', '', 0, 0, '', '', '[\"POST /admin/member-money-log/edit\",\"GET /admin/member-money-log/view\"]', 0, 0, 0, '', '', 0, 0, 3, 1, '', 0, 0, 1770881561, 1770881561),
(515, 511, 3, '删除余额变动日志', 'MemberMoneyLogDelete', '', '', '', '', 0, 0, '', '', '[\"POST /admin/member-money-log/delete\"]', 0, 0, 0, '', '', 0, 0, 4, 1, '', 0, 0, 1770881561, 1770881561),
(516, 511, 3, '导出余额变动日志', 'MemberMoneyLogExport', '', '', '', '', 0, 0, '', '', '[\"GET /admin/member-money-log/export\"]', 0, 0, 0, '', '', 0, 0, 5, 1, '', 0, 0, 1770881561, 1770881561),
(517, 143, 2, '积分变动日志', 'MemberScoreLog', 'member-score-log', '/member/member-score-log/index', '', 'ri:file-list-line', 0, 1, '', '', '[\"GET /admin/member-score-log/list\"]', 0, 0, 0, '', '', 0, 0, 100, 1, '', 0, 0, 1770881700, 1770881700),
(617, 143, 2, '会员通知', 'MemberNotice', 'member-notice', '/member/member-notice/index', '', 'ri:notification-line', 0, 1, '', '', '[\"GET /admin/member-notice/list\"]', 0, 0, 0, '', '', 0, 0, 100, 1, '', 0, 0, 1770904531, 1770904531),
(618, 617, 3, '查看会员通知', 'MemberNoticeView', '', '', '', '', 0, 0, '', '', '[\"GET /admin/member-notice/view\"]', 0, 0, 0, '', '', 0, 0, 1, 1, '', 0, 0, 1770904531, 1770904531),
(619, 617, 3, '新增会员通知', 'MemberNoticeAdd', '', '', '', '', 0, 0, '', '', '[\"POST /admin/member-notice/edit\"]', 0, 0, 0, '', '', 0, 0, 2, 1, '', 0, 0, 1770904531, 1770904531),
(620, 617, 3, '编辑会员通知', 'MemberNoticeEdit', '', '', '', '', 0, 0, '', '', '[\"POST /admin/member-notice/edit\",\"GET /admin/member-notice/view\"]', 0, 0, 0, '', '', 0, 0, 3, 1, '', 0, 0, 1770904531, 1770904531),
(621, 617, 3, '删除会员通知', 'MemberNoticeDelete', '', '', '', '', 0, 0, '', '', '[\"POST /admin/member-notice/delete\"]', 0, 0, 0, '', '', 0, 0, 4, 1, '', 0, 0, 1770904531, 1770904531),
(622, 617, 3, '导出会员通知', 'MemberNoticeExport', '', '', '', '', 0, 0, '', '', '[\"GET /admin/member-notice/export\"]', 0, 0, 0, '', '', 0, 0, 5, 1, '', 0, 0, 1770904531, 1770904531);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_notice`
--

CREATE TABLE `xy_admin_notice` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键',
  `title` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '类型:1=通知,2=公告,3=私信',
  `content` text COLLATE utf8mb4_general_ci COMMENT '内容(HTML)',
  `tag` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签(info/success/warning/danger)',
  `sender_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '发送人ID(0=系统)',
  `receiver_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '接收人ID(0=全员)',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:1=正常,2=关闭',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `read_count` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '已读人数',
  `created_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='通知消息表';

--
-- 转存表中的数据 `xy_admin_notice`
--

INSERT INTO `xy_admin_notice` (`id`, `title`, `type`, `content`, `tag`, `sender_id`, `receiver_id`, `status`, `sort`, `remark`, `read_count`, `created_at`, `updated_at`) VALUES
(1, 'test a notify', 1, '我来了', 'info', 1, 0, 1, 0, '', 2, 1770706024, 1770708972);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_notice_read`
--

CREATE TABLE `xy_admin_notice_read` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键',
  `notice_id` bigint(20) UNSIGNED NOT NULL COMMENT '通知ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `read_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '阅读时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='通知已读记录表';

--
-- 转存表中的数据 `xy_admin_notice_read`
--

INSERT INTO `xy_admin_notice_read` (`id`, `notice_id`, `user_id`, `read_at`) VALUES
(1, 1, 1, 1770706027),
(2, 1, 2, 1770708972);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_operation_log`
--

CREATE TABLE `xy_admin_operation_log` (
  `id` int(10) UNSIGNED NOT NULL COMMENT '日志ID',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '操作人ID',
  `username` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作人账号',
  `module` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '模块名称（如：用户管理、角色管理）',
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作标题/接口描述',
  `method` varchar(10) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'HTTP方法（GET/POST/PUT/DELETE）',
  `url` varchar(500) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '请求URL',
  `ip` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作IP',
  `location` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '操作地点',
  `user_agent` varchar(500) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `request_body` text COLLATE utf8mb4_general_ci COMMENT '请求参数（JSON）',
  `response_body` text COLLATE utf8mb4_general_ci COMMENT '响应结果（JSON，可选截断存储）',
  `error_message` varchar(1000) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '错误信息',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0=失败 1=成功',
  `elapsed` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '耗时（毫秒）',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='管理员操作日志';

--
-- 转存表中的数据 `xy_admin_operation_log`
--

INSERT INTO `xy_admin_operation_log` (`id`, `user_id`, `username`, `module`, `title`, `method`, `url`, `ip`, `location`, `user_agent`, `request_body`, `response_body`, `error_message`, `status`, `elapsed`, `created_at`) VALUES
(831, 1, 'admin', '操作日志', '清空日志', 'POST', '/admin/log/operation/clear', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '', '', '', 1, 111, 1770909791),
(832, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 30, 1770909794),
(833, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 176, 1770909794),
(834, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770909800),
(835, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 4, 1770909800),
(836, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770909808),
(837, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 1, 1770909808),
(838, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 2, 1770909880),
(839, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 4, 1770909880),
(840, 1, 'admin', '登录日志', '清空日志', 'POST', '/admin/log/login/clear', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '', '', '', 1, 109, 1770909944),
(841, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 11, 1770909994),
(842, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 17, 1770909994),
(843, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 8, 1770910322),
(844, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 6, 1770910322),
(845, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 11, 1770910322),
(846, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 7, 1770910322),
(847, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 2, 1770910353),
(848, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 5, 1770910353),
(849, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770910356),
(850, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 7, 1770910356),
(851, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 0, 1770910357),
(852, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 2, 1770910357),
(853, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 4, 1770910370),
(854, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 5, 1770910370),
(855, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 13, 1770910370),
(856, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 12, 1770910370),
(857, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 0, 1770910387),
(858, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 2, 1770910387),
(859, 1, 'admin', 'menu', 'POST /admin/menu/save', 'POST', '/admin/menu/save', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":164,\"parentId\":110,\"type\":2,\"title\":\"性能分析\",\"name\":\"SafeguardPerformance\",\"path\":\"performance\",\"component\":\"/safeguard/performance\",\"icon\":\"ri:line-chart-line\",\"resource\":\"admin_operation_log\",\"hidden\":0,\"hideTab\":0,\"keepAlive\":0,\"redirect\":\"\",\"frameSrc\":\"\",\"perms\":\"\",\"isFrame\":0,\"affix\":0,\"showBadge\":0,\"badgeText\":\"\",\"activePath\":\"\",\"isFullPage\":0,\"sort\":124,\"status\":1,\"remark\":\"\"}', '', '', 1, 94, 1770910442),
(860, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770910448),
(861, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 5, 1770910448),
(862, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770910471),
(863, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 2, 1770910472),
(864, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770910477),
(865, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 17, 1770910477),
(866, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770910481),
(867, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 3, 1770910481),
(868, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 0, 1770910485),
(869, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 3, 1770910485),
(870, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 3, 1770910509),
(871, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 2, 1770910509),
(872, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770910511),
(873, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 1, 1770910511),
(874, 1, 'admin', '会员通知', '编辑会员通知', 'POST', '/admin/member-notice/edit', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":0,\"title\":\"test a notify\",\"content\":\"<p>这是一个测试通知</p>\",\"type\":\"system\",\"target\":\"all\",\"targetId\":0,\"sender\":\"Xygo\",\"status\":1}', '', '', 1, 59, 1770910671),
(875, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/delete', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":39,\"deleteFiles\":true,\"deleteMenus\":true}', '', '', 1, 139, 1770911898),
(876, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/delete', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":38,\"deleteFiles\":true,\"deleteMenus\":true}', '', '', 1, 75, 1770911907),
(877, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/preview', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":0,\"genType\":10,\"dbName\":\"\",\"tableName\":\"xy_test_code\",\"tableComment\":\"测试生成\",\"varName\":\"TestCode\",\"options\":\"{\\\"genType\\\":10,\\\"headOps\\\":[\\\"add\\\",\\\"batchDel\\\",\\\"export\\\"],\\\"columnOps\\\":[\\\"edit\\\",\\\"del\\\",\\\"view\\\",\\\"status\\\",\\\"check\\\"],\\\"autoOps\\\":[\\\"genMenuPermissions\\\",\\\"runDao\\\",\\\"runService\\\"],\\\"viewMode\\\":\\\"drawer\\\",\\\"apiPrefix\\\":\\\"\\\",\\\"genPaths\\\":{},\\\"menu\\\":{\\\"pid\\\":0,\\\"icon\\\":\\\"ri:file-list-line\\\",\\\"sort\\\":100},\\\"tree\\\":{\\\"titleColumn\\\":\\\"name\\\",\\\"pidColumn\\\":\\\"parent_id\\\"}}\",\"columns\":[{\"id\":0,\"genId\":0,\"name\":\"id\",\"goName\":\"Id\",\"tsName\":\"id\",\"dbType\":\"bigint(20) unsigned\",\"goType\":\"uint64\",\"tsType\":\"number\",\"comment\":\"主键\",\"isPk\":1,\"isRequired\":0,\"isList\":1,\"isEdit\":0,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"input\",\"designType\":\"pk\",\"extra\":\"\",\"dictType\":\"\",\"sort\":1},{\"id\":0,\"genId\":0,\"name\":\"name\",\"goName\":\"Name\",\"tsName\":\"name\",\"dbType\":\"varchar(100)\",\"goType\":\"string\",\"tsType\":\"string\",\"comment\":\"名称\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":1,\"queryType\":\"like\",\"formType\":\"input\",\"designType\":\"string\",\"extra\":\"\",\"dictType\":\"\",\"sort\":2},{\"id\":0,\"genId\":0,\"name\":\"member_id\",\"goName\":\"MemberId\",\"tsName\":\"memberId\",\"dbType\":\"int(10) unsigned\",\"goType\":\"uint\",\"tsType\":\"number\",\"comment\":\"关联ID\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"remoteSelect\",\"designType\":\"remoteSelect\",\"extra\":\"{\\\"_formProps\\\":{\\\"validator\\\":[],\\\"validatorMsg\\\":\\\"\\\",\\\"remote-table\\\":\\\"xy_member_login_log\\\",\\\"remote-pk\\\":\\\"id\\\",\\\"remote-field\\\":\\\"username\\\",\\\"relation-fields-config\\\":\\\"[{\\\\\\\"field\\\\\\\":\\\\\\\"id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"member_id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"username\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"用户名\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"ip\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"登录IP\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"user_agent\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"User-Agent\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"status\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"状态\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"message\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"提示信息\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"created_at\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"创建时间\\\\\\\",\\\\\\\"inList\\\\\\\":true,\\\\\\\"inSearch\\\\\\\":true,\\\\\\\"inExport\\\\\\\":true,\\\\\\\"searchType\\\\\\\":\\\\\\\"between\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"datetimerange\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"}]\\\",\\\"relation-fields\\\":\\\"created_at\\\",\\\"relation-search-fields\\\":\\\"created_at\\\",\\\"relation-export-fields\\\":\\\"created_at\\\"},\\\"_tableProps\\\":{\\\"render\\\":\\\"none\\\",\\\"operator\\\":\\\"eq\\\",\\\"sortable\\\":\\\"false\\\"}}\",\"dictType\":\"\",\"sort\":3}]}', '', '', 1, 12, 1770911986),
(878, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/edit', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":0,\"genType\":10,\"dbName\":\"\",\"tableName\":\"xy_test_code\",\"tableComment\":\"测试生成\",\"varName\":\"TestCode\",\"options\":\"{\\\"genType\\\":10,\\\"headOps\\\":[\\\"add\\\",\\\"batchDel\\\",\\\"export\\\"],\\\"columnOps\\\":[\\\"edit\\\",\\\"del\\\",\\\"view\\\",\\\"status\\\",\\\"check\\\"],\\\"autoOps\\\":[\\\"genMenuPermissions\\\",\\\"runDao\\\",\\\"runService\\\"],\\\"viewMode\\\":\\\"drawer\\\",\\\"apiPrefix\\\":\\\"\\\",\\\"genPaths\\\":{},\\\"menu\\\":{\\\"pid\\\":0,\\\"icon\\\":\\\"ri:file-list-line\\\",\\\"sort\\\":100},\\\"tree\\\":{\\\"titleColumn\\\":\\\"name\\\",\\\"pidColumn\\\":\\\"parent_id\\\"}}\",\"columns\":[{\"id\":0,\"genId\":0,\"name\":\"id\",\"goName\":\"Id\",\"tsName\":\"id\",\"dbType\":\"bigint(20) unsigned\",\"goType\":\"uint64\",\"tsType\":\"number\",\"comment\":\"主键\",\"isPk\":1,\"isRequired\":0,\"isList\":1,\"isEdit\":0,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"input\",\"designType\":\"pk\",\"extra\":\"\",\"dictType\":\"\",\"sort\":1},{\"id\":0,\"genId\":0,\"name\":\"name\",\"goName\":\"Name\",\"tsName\":\"name\",\"dbType\":\"varchar(100)\",\"goType\":\"string\",\"tsType\":\"string\",\"comment\":\"名称\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":1,\"queryType\":\"like\",\"formType\":\"input\",\"designType\":\"string\",\"extra\":\"\",\"dictType\":\"\",\"sort\":2},{\"id\":0,\"genId\":0,\"name\":\"member_id\",\"goName\":\"MemberId\",\"tsName\":\"memberId\",\"dbType\":\"int(10) unsigned\",\"goType\":\"uint\",\"tsType\":\"number\",\"comment\":\"关联ID\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"remoteSelect\",\"designType\":\"remoteSelect\",\"extra\":\"{\\\"_formProps\\\":{\\\"validator\\\":[],\\\"validatorMsg\\\":\\\"\\\",\\\"remote-table\\\":\\\"xy_member_login_log\\\",\\\"remote-pk\\\":\\\"id\\\",\\\"remote-field\\\":\\\"username\\\",\\\"relation-fields-config\\\":\\\"[{\\\\\\\"field\\\\\\\":\\\\\\\"id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"member_id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"username\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"用户名\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"ip\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"登录IP\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"user_agent\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"User-Agent\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"status\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"状态\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"message\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"提示信息\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"created_at\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"创建时间\\\\\\\",\\\\\\\"inList\\\\\\\":true,\\\\\\\"inSearch\\\\\\\":true,\\\\\\\"inExport\\\\\\\":true,\\\\\\\"searchType\\\\\\\":\\\\\\\"between\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"datetimerange\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"}]\\\",\\\"relation-fields\\\":\\\"created_at\\\",\\\"relation-search-fields\\\":\\\"created_at\\\",\\\"relation-export-fields\\\":\\\"created_at\\\"},\\\"_tableProps\\\":{\\\"render\\\":\\\"none\\\",\\\"operator\\\":\\\"eq\\\",\\\"sortable\\\":\\\"false\\\"}}\",\"dictType\":\"\",\"sort\":3}]}', '', '', 1, 59, 1770911988),
(879, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/build', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":0,\"genType\":10,\"dbName\":\"\",\"tableName\":\"xy_test_code\",\"tableComment\":\"测试生成\",\"varName\":\"TestCode\",\"options\":\"{\\\"genType\\\":10,\\\"headOps\\\":[\\\"add\\\",\\\"batchDel\\\",\\\"export\\\"],\\\"columnOps\\\":[\\\"edit\\\",\\\"del\\\",\\\"view\\\",\\\"status\\\",\\\"check\\\"],\\\"autoOps\\\":[\\\"genMenuPermissions\\\",\\\"runDao\\\",\\\"runService\\\"],\\\"viewMode\\\":\\\"drawer\\\",\\\"apiPrefix\\\":\\\"\\\",\\\"genPaths\\\":{},\\\"menu\\\":{\\\"pid\\\":0,\\\"icon\\\":\\\"ri:file-list-line\\\",\\\"sort\\\":100},\\\"tree\\\":{\\\"titleColumn\\\":\\\"name\\\",\\\"pidColumn\\\":\\\"parent_id\\\"}}\",\"columns\":[{\"id\":0,\"genId\":0,\"name\":\"id\",\"goName\":\"Id\",\"tsName\":\"id\",\"dbType\":\"bigint(20) unsigned\",\"goType\":\"uint64\",\"tsType\":\"number\",\"comment\":\"主键\",\"isPk\":1,\"isRequired\":0,\"isList\":1,\"isEdit\":0,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"input\",\"designType\":\"pk\",\"extra\":\"\",\"dictType\":\"\",\"sort\":1},{\"id\":0,\"genId\":0,\"name\":\"name\",\"goName\":\"Name\",\"tsName\":\"name\",\"dbType\":\"varchar(100)\",\"goType\":\"string\",\"tsType\":\"string\",\"comment\":\"名称\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":1,\"queryType\":\"like\",\"formType\":\"input\",\"designType\":\"string\",\"extra\":\"\",\"dictType\":\"\",\"sort\":2},{\"id\":0,\"genId\":0,\"name\":\"member_id\",\"goName\":\"MemberId\",\"tsName\":\"memberId\",\"dbType\":\"int(10) unsigned\",\"goType\":\"uint\",\"tsType\":\"number\",\"comment\":\"关联ID\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"remoteSelect\",\"designType\":\"remoteSelect\",\"extra\":\"{\\\"_formProps\\\":{\\\"validator\\\":[],\\\"validatorMsg\\\":\\\"\\\",\\\"remote-table\\\":\\\"xy_member_login_log\\\",\\\"remote-pk\\\":\\\"id\\\",\\\"remote-field\\\":\\\"username\\\",\\\"relation-fields-config\\\":\\\"[{\\\\\\\"field\\\\\\\":\\\\\\\"id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"member_id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"username\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"用户名\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"ip\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"登录IP\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"user_agent\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"User-Agent\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"status\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"状态\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"message\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"提示信息\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"created_at\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"创建时间\\\\\\\",\\\\\\\"inList\\\\\\\":true,\\\\\\\"inSearch\\\\\\\":true,\\\\\\\"inExport\\\\\\\":true,\\\\\\\"searchType\\\\\\\":\\\\\\\"between\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"datetimerange\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"}]\\\",\\\"relation-fields\\\":\\\"created_at\\\",\\\"relation-search-fields\\\":\\\"created_at\\\",\\\"relation-export-fields\\\":\\\"created_at\\\"},\\\"_tableProps\\\":{\\\"render\\\":\\\"none\\\",\\\"operator\\\":\\\"eq\\\",\\\"sortable\\\":\\\"false\\\"}}\",\"dictType\":\"\",\"sort\":3}]}', '', '', 1, 636, 1770911989),
(880, 1, 'admin', 'genCodes', 'POST /admin/genCodes/publishFrontend', 'POST', '/admin/genCodes/publishFrontend', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '', '', '', 1, 15, 1770911998),
(881, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/delete', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":68,\"deleteFiles\":true,\"deleteMenus\":true}', '', 'DELETE FROM `xy_sys_gen_codes` WHERE `id`=68: context canceled', 0, 132, 1770912378),
(882, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/preview', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":0,\"genType\":10,\"dbName\":\"\",\"tableName\":\"xy_test_code\",\"tableComment\":\"测试生成\",\"varName\":\"TestCode\",\"options\":\"{\\\"genType\\\":10,\\\"headOps\\\":[\\\"add\\\",\\\"batchDel\\\",\\\"export\\\"],\\\"columnOps\\\":[\\\"edit\\\",\\\"del\\\",\\\"view\\\",\\\"status\\\",\\\"check\\\"],\\\"autoOps\\\":[\\\"genMenuPermissions\\\",\\\"runDao\\\",\\\"runService\\\"],\\\"viewMode\\\":\\\"drawer\\\",\\\"apiPrefix\\\":\\\"\\\",\\\"genPaths\\\":{},\\\"menu\\\":{\\\"pid\\\":0,\\\"icon\\\":\\\"ri:file-list-line\\\",\\\"sort\\\":100},\\\"tree\\\":{\\\"titleColumn\\\":\\\"name\\\",\\\"pidColumn\\\":\\\"parent_id\\\"}}\",\"columns\":[{\"id\":0,\"genId\":0,\"name\":\"id\",\"goName\":\"Id\",\"tsName\":\"id\",\"dbType\":\"bigint(20) unsigned\",\"goType\":\"uint64\",\"tsType\":\"number\",\"comment\":\"主键\",\"isPk\":1,\"isRequired\":0,\"isList\":1,\"isEdit\":0,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"input\",\"designType\":\"pk\",\"extra\":\"\",\"dictType\":\"\",\"sort\":1},{\"id\":0,\"genId\":0,\"name\":\"name\",\"goName\":\"Name\",\"tsName\":\"name\",\"dbType\":\"varchar(100)\",\"goType\":\"string\",\"tsType\":\"string\",\"comment\":\"名称\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":1,\"queryType\":\"like\",\"formType\":\"input\",\"designType\":\"string\",\"extra\":\"\",\"dictType\":\"\",\"sort\":2},{\"id\":0,\"genId\":0,\"name\":\"member_id\",\"goName\":\"MemberId\",\"tsName\":\"memberId\",\"dbType\":\"int(10) unsigned\",\"goType\":\"uint\",\"tsType\":\"number\",\"comment\":\"关联ID\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"remoteSelect\",\"designType\":\"remoteSelect\",\"extra\":\"{\\\"_formProps\\\":{\\\"validator\\\":[],\\\"validatorMsg\\\":\\\"\\\",\\\"remote-table\\\":\\\"xy_member\\\",\\\"remote-pk\\\":\\\"id\\\",\\\"remote-field\\\":\\\"nickname\\\",\\\"relation-fields-config\\\":\\\"[{\\\\\\\"field\\\\\\\":\\\\\\\"id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"username\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"用户名\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"password\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"密码（bcrypt加密）\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"mobile\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"手机号\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"email\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"邮箱\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"nickname\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"昵称\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"avatar\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"头像\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"gender\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"性别\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"birthday\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"生日\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"money\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"余额\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"score\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"积分\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"level\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员等级\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"group_id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员分组ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"status\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"状态\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"last_login_ip\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"最后登录IP\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchCompo...(truncated)', '', '', 1, 16, 1770912448),
(883, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/edit', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":0,\"genType\":10,\"dbName\":\"\",\"tableName\":\"xy_test_code\",\"tableComment\":\"测试生成\",\"varName\":\"TestCode\",\"options\":\"{\\\"genType\\\":10,\\\"headOps\\\":[\\\"add\\\",\\\"batchDel\\\",\\\"export\\\"],\\\"columnOps\\\":[\\\"edit\\\",\\\"del\\\",\\\"view\\\",\\\"status\\\",\\\"check\\\"],\\\"autoOps\\\":[\\\"genMenuPermissions\\\",\\\"runDao\\\",\\\"runService\\\"],\\\"viewMode\\\":\\\"drawer\\\",\\\"apiPrefix\\\":\\\"\\\",\\\"genPaths\\\":{},\\\"menu\\\":{\\\"pid\\\":0,\\\"icon\\\":\\\"ri:file-list-line\\\",\\\"sort\\\":100},\\\"tree\\\":{\\\"titleColumn\\\":\\\"name\\\",\\\"pidColumn\\\":\\\"parent_id\\\"}}\",\"columns\":[{\"id\":0,\"genId\":0,\"name\":\"id\",\"goName\":\"Id\",\"tsName\":\"id\",\"dbType\":\"bigint(20) unsigned\",\"goType\":\"uint64\",\"tsType\":\"number\",\"comment\":\"主键\",\"isPk\":1,\"isRequired\":0,\"isList\":1,\"isEdit\":0,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"input\",\"designType\":\"pk\",\"extra\":\"\",\"dictType\":\"\",\"sort\":1},{\"id\":0,\"genId\":0,\"name\":\"name\",\"goName\":\"Name\",\"tsName\":\"name\",\"dbType\":\"varchar(100)\",\"goType\":\"string\",\"tsType\":\"string\",\"comment\":\"名称\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":1,\"queryType\":\"like\",\"formType\":\"input\",\"designType\":\"string\",\"extra\":\"\",\"dictType\":\"\",\"sort\":2},{\"id\":0,\"genId\":0,\"name\":\"member_id\",\"goName\":\"MemberId\",\"tsName\":\"memberId\",\"dbType\":\"int(10) unsigned\",\"goType\":\"uint\",\"tsType\":\"number\",\"comment\":\"关联ID\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"remoteSelect\",\"designType\":\"remoteSelect\",\"extra\":\"{\\\"_formProps\\\":{\\\"validator\\\":[],\\\"validatorMsg\\\":\\\"\\\",\\\"remote-table\\\":\\\"xy_member\\\",\\\"remote-pk\\\":\\\"id\\\",\\\"remote-field\\\":\\\"nickname\\\",\\\"relation-fields-config\\\":\\\"[{\\\\\\\"field\\\\\\\":\\\\\\\"id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"username\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"用户名\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"password\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"密码（bcrypt加密）\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"mobile\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"手机号\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"email\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"邮箱\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"nickname\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"昵称\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"avatar\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"头像\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"gender\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"性别\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"birthday\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"生日\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"money\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"余额\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"score\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"积分\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"level\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员等级\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"group_id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员分组ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"status\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"状态\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"last_login_ip\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"最后登录IP\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchCompo...(truncated)', '', '', 1, 76, 1770912450);
INSERT INTO `xy_admin_operation_log` (`id`, `user_id`, `username`, `module`, `title`, `method`, `url`, `ip`, `location`, `user_agent`, `request_body`, `response_body`, `error_message`, `status`, `elapsed`, `created_at`) VALUES
(884, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/build', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":0,\"genType\":10,\"dbName\":\"\",\"tableName\":\"xy_test_code\",\"tableComment\":\"测试生成\",\"varName\":\"TestCode\",\"options\":\"{\\\"genType\\\":10,\\\"headOps\\\":[\\\"add\\\",\\\"batchDel\\\",\\\"export\\\"],\\\"columnOps\\\":[\\\"edit\\\",\\\"del\\\",\\\"view\\\",\\\"status\\\",\\\"check\\\"],\\\"autoOps\\\":[\\\"genMenuPermissions\\\",\\\"runDao\\\",\\\"runService\\\"],\\\"viewMode\\\":\\\"drawer\\\",\\\"apiPrefix\\\":\\\"\\\",\\\"genPaths\\\":{},\\\"menu\\\":{\\\"pid\\\":0,\\\"icon\\\":\\\"ri:file-list-line\\\",\\\"sort\\\":100},\\\"tree\\\":{\\\"titleColumn\\\":\\\"name\\\",\\\"pidColumn\\\":\\\"parent_id\\\"}}\",\"columns\":[{\"id\":0,\"genId\":0,\"name\":\"id\",\"goName\":\"Id\",\"tsName\":\"id\",\"dbType\":\"bigint(20) unsigned\",\"goType\":\"uint64\",\"tsType\":\"number\",\"comment\":\"主键\",\"isPk\":1,\"isRequired\":0,\"isList\":1,\"isEdit\":0,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"input\",\"designType\":\"pk\",\"extra\":\"\",\"dictType\":\"\",\"sort\":1},{\"id\":0,\"genId\":0,\"name\":\"name\",\"goName\":\"Name\",\"tsName\":\"name\",\"dbType\":\"varchar(100)\",\"goType\":\"string\",\"tsType\":\"string\",\"comment\":\"名称\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":1,\"queryType\":\"like\",\"formType\":\"input\",\"designType\":\"string\",\"extra\":\"\",\"dictType\":\"\",\"sort\":2},{\"id\":0,\"genId\":0,\"name\":\"member_id\",\"goName\":\"MemberId\",\"tsName\":\"memberId\",\"dbType\":\"int(10) unsigned\",\"goType\":\"uint\",\"tsType\":\"number\",\"comment\":\"关联ID\",\"isPk\":0,\"isRequired\":1,\"isList\":1,\"isEdit\":1,\"isQuery\":0,\"queryType\":\"eq\",\"formType\":\"remoteSelect\",\"designType\":\"remoteSelect\",\"extra\":\"{\\\"_formProps\\\":{\\\"validator\\\":[],\\\"validatorMsg\\\":\\\"\\\",\\\"remote-table\\\":\\\"xy_member\\\",\\\"remote-pk\\\":\\\"id\\\",\\\"remote-field\\\":\\\"nickname\\\",\\\"relation-fields-config\\\":\\\"[{\\\\\\\"field\\\\\\\":\\\\\\\"id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"username\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"用户名\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"password\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"密码（bcrypt加密）\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"mobile\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"手机号\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"email\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"邮箱\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"nickname\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"昵称\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"avatar\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"头像\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"gender\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"性别\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"birthday\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"生日\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"money\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"余额\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"score\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"积分\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"level\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员等级\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"group_id\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"会员分组ID\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"status\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"状态\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchComponent\\\\\\\":\\\\\\\"input\\\\\\\",\\\\\\\"listRender\\\\\\\":\\\\\\\"text\\\\\\\"},{\\\\\\\"field\\\\\\\":\\\\\\\"last_login_ip\\\\\\\",\\\\\\\"label\\\\\\\":\\\\\\\"最后登录IP\\\\\\\",\\\\\\\"inList\\\\\\\":false,\\\\\\\"inSearch\\\\\\\":false,\\\\\\\"inExport\\\\\\\":false,\\\\\\\"searchType\\\\\\\":\\\\\\\"like\\\\\\\",\\\\\\\"searchCompo...(truncated)', '', '', 1, 564, 1770912451),
(885, 1, 'admin', 'genCodes', 'POST /admin/genCodes/publishFrontend', 'POST', '/admin/genCodes/publishFrontend', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '', '', '', 1, 15, 1770912461),
(886, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 3, 1770912511),
(887, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 4, 1770912511),
(888, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770912525),
(889, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 3, 1770912525),
(890, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 0, 1770912528),
(891, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 2, 1770912528),
(892, 1, 'admin', 'menu', 'POST /admin/menu/save', 'POST', '/admin/menu/save', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":164,\"parentId\":110,\"type\":2,\"title\":\"性能分析\",\"name\":\"SafeguardPerformance\",\"path\":\"performance\",\"component\":\"/safeguard/performance\",\"icon\":\"ri:line-chart-line\",\"resource\":\"admin_operation_log\",\"hidden\":0,\"hideTab\":0,\"keepAlive\":0,\"redirect\":\"\",\"frameSrc\":\"\",\"perms\":\"\",\"isFrame\":0,\"affix\":0,\"showBadge\":0,\"badgeText\":\"\",\"activePath\":\"\",\"isFullPage\":0,\"sort\":124,\"status\":1,\"remark\":\"\"}', '', '', 1, 3, 1770912625),
(893, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 2, 1770912649),
(894, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 2, 1770912649),
(895, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770912654),
(896, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 2, 1770912654),
(897, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 2, 1770912659),
(898, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 3, 1770912659),
(899, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770912670),
(900, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 3, 1770912670),
(901, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 3, 1770912755),
(902, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 5, 1770912755),
(903, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770912760),
(904, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 3, 1770912760),
(905, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770912765),
(906, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 3, 1770912765),
(907, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770912768),
(908, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 4, 1770912768),
(909, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 2, 1770912807),
(910, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 5, 1770912807),
(911, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770912811),
(912, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 3, 1770912811),
(913, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770912816),
(914, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 5, 1770912816),
(915, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770912830),
(916, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 5, 1770912830),
(917, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 2, 1770913038),
(918, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 4, 1770913038),
(919, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\",\"limit\":20}', '', '', 1, 1, 1770913041),
(920, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"startDate\":\"2026-02-12\",\"endDate\":\"2026-02-12\"}', '', '', 1, 3, 1770913041),
(921, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/delete', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{\"id\":68,\"deleteFiles\":true,\"deleteMenus\":true}', '', '', 1, 163, 1770913411);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_post`
--

CREATE TABLE `xy_admin_post` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '岗位ID',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序(越小越靠前)',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  `created_by` bigint(20) UNSIGNED DEFAULT '0' COMMENT '创建人ID',
  `updated_by` bigint(20) UNSIGNED DEFAULT '0' COMMENT '更新人ID',
  `create_time` int(10) UNSIGNED DEFAULT '0' COMMENT '创建时间',
  `update_time` int(10) UNSIGNED DEFAULT '0' COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='岗位表';

--
-- 转存表中的数据 `xy_admin_post`
--

INSERT INTO `xy_admin_post` (`id`, `code`, `name`, `sort`, `status`, `remark`, `created_by`, `updated_by`, `create_time`, `update_time`) VALUES
(1, 'CEO', '董事长', 1, 1, '公司最高管理者', 0, 0, 1768556833, 1768556833),
(2, 'CTO', '技术总监', 2, 1, '技术部门负责人', 0, 0, 1768556833, 1768556833),
(3, 'CFO', '财务总监', 3, 1, '财务部门负责人', 0, 0, 1768556833, 1768556833),
(4, 'PM', '产品经理', 4, 1, '产品规划与设计', 0, 0, 1768556833, 1768556833),
(5, 'DEV', '开发工程师', 5, 1, '软件开发', 0, 0, 1768556833, 1768556833),
(6, 'QA', '测试工程师', 6, 1, '质量保证', 0, 0, 1768556833, 1768556833),
(7, 'UI', 'UI设计师', 7, 1, '用户界面设计', 0, 0, 1768556833, 1768556833);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_role`
--

CREATE TABLE `xy_admin_role` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '角色ID',
  `name` varchar(50) NOT NULL COMMENT '角色名称',
  `key` varchar(50) NOT NULL COMMENT '角色标识(英文唯一)',
  `data_scope` tinyint(4) NOT NULL DEFAULT '0' COMMENT '数据范围:0=全部,1=本部门,2=本部门及子,3=仅本人,4=自定义部门',
  `custom_depts` text COMMENT '自定义数据范围部门ID列表(JSON数组)',
  `pid` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '上级角色ID',
  `level` bigint(20) NOT NULL DEFAULT '1' COMMENT '关系树等级（根为1）',
  `tree` varchar(255) NOT NULL DEFAULT '0' COMMENT '关系树路径，如 0,1,3',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序（越小越靠前）',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `created_by` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `updated_by` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `create_time` int(10) UNSIGNED NOT NULL COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='后台角色表';

--
-- 转存表中的数据 `xy_admin_role`
--

INSERT INTO `xy_admin_role` (`id`, `name`, `key`, `data_scope`, `custom_depts`, `pid`, `level`, `tree`, `sort`, `status`, `remark`, `created_by`, `updated_by`, `create_time`, `update_time`) VALUES
(1, '超级管理员', 'super_admin', 0, '[]', 0, 1, '0', 0, 1, '系统内置超级管理员11', 1, 0, 1768560139, 1768560139),
(2, '运维管理员', 'ops_admin', 2, '[]', 1, 2, '0,1', 0, 1, '负责运维与系统配置', 1, 0, 1768560139, 1768560139),
(3, '业务管理员', 'biz_admin', 1, '[]', 1, 2, '0,1', 0, 1, '负责业务数据管理', 1, 0, 1768560139, 1768560139),
(4, '访客', 'viewer', 3, '', 3, 3, '0,1,3', 0, 1, '只读访问权限', 1, 0, 1768560139, 1768560139),
(5, '测试二号管理员', 'node_add', 0, '[]', 1, 2, '0,1', 0, 1, '一个测试管理员', 0, 0, 1768560139, 1768560139);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_role_menu`
--

CREATE TABLE `xy_admin_role_menu` (
  `role_id` bigint(20) UNSIGNED NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) UNSIGNED NOT NULL COMMENT '菜单ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色-菜单关联表';

--
-- 转存表中的数据 `xy_admin_role_menu`
--

INSERT INTO `xy_admin_role_menu` (`role_id`, `menu_id`) VALUES
(2, 1),
(4, 1),
(2, 2),
(4, 2),
(2, 3),
(4, 3),
(2, 4),
(4, 4),
(4, 61),
(2, 80),
(2, 81),
(2, 82),
(2, 83),
(2, 84),
(2, 110),
(2, 111),
(4, 122),
(4, 123),
(4, 124),
(4, 125),
(4, 141),
(2, 144),
(2, 157),
(2, 158),
(2, 159),
(2, 160),
(2, 161),
(2, 162),
(2, 163),
(2, 164),
(2, 202);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_user`
--

CREATE TABLE `xy_admin_user` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '管理员ID',
  `username` varchar(50) NOT NULL COMMENT '登录账号',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `password` varchar(255) NOT NULL COMMENT '密码哈希',
  `gender` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别0保密 1男 2女',
  `salt` varchar(50) NOT NULL DEFAULT '' COMMENT '密码盐',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
  `address` varchar(255) DEFAULT NULL COMMENT '地址',
  `remark` varchar(500) DEFAULT NULL COMMENT '个人简介',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '邮箱',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `dept_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '部门ID',
  `pid` bigint(20) UNSIGNED DEFAULT '0' COMMENT '上级用户ID（直属上级）',
  `is_super` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否超管:0=否,1=是',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `last_login_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'last login time',
  `last_login_ip` varchar(50) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `created_by` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `updated_by` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `create_time` int(10) UNSIGNED DEFAULT NULL COMMENT '创建时间',
  `update_time` int(10) UNSIGNED DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='后台管理员表';

--
-- 转存表中的数据 `xy_admin_user`
--

INSERT INTO `xy_admin_user` (`id`, `username`, `nickname`, `real_name`, `password`, `gender`, `salt`, `mobile`, `address`, `remark`, `email`, `avatar`, `dept_id`, `pid`, `is_super`, `status`, `last_login_at`, `last_login_ip`, `created_by`, `updated_by`, `create_time`, `update_time`) VALUES
(1, 'admin', '超级管理员', '系统管理员', 'e10adc3949ba59abbe56e057f20f883e', 1, '', '15524812851', '辽宁省-大连市-开发区', '一个又懒又爱又帅气得男人', '751300685@qq.com', '/attachment/upload/20260210/2c2ddd0e-e4b2-4b76-ba31-1d992de4e0d7.webp', 0, 0, 1, 1, NULL, '', 0, 0, 1768575212, 1768575212),
(2, 'admin2', '测试用户2', NULL, '7e8bc594d2dfd02d6ba7b51aa34d839e', 2, 'AwDVkR', '15241328852', NULL, NULL, 'aaaa@qq.com', '', 2, 0, 0, 1, NULL, '', 1, 1, 1770708367, 1770708956),
(3, 'testzong', '测试总公司', NULL, '222ea6a32ab043cf11315020d5a828f9', 1, 'eSDG3M', '13895281214', NULL, NULL, 'aaa@qq.com', '', 1, 0, 0, 1, NULL, '', 1, 1, 1770711284, 1770711284),
(4, 'xingxing', '星韵', NULL, '38a82d3031b16b189ef047fdd897c331', 1, '6lmWUd', '13898521473', NULL, NULL, 'bbb@qq.com', '/attachment/upload/20260210/0a27edcc-e96c-4b2e-95f9-b69c772cde82.webp', 5, 0, 0, 1, NULL, '', 1, 1, 1770711602, 1770711828);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_user_post`
--

CREATE TABLE `xy_admin_user_post` (
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) UNSIGNED NOT NULL COMMENT '岗位ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户岗位关联表';

--
-- 转存表中的数据 `xy_admin_user_post`
--

INSERT INTO `xy_admin_user_post` (`user_id`, `post_id`) VALUES
(2, 2),
(3, 1),
(4, 2);

-- --------------------------------------------------------

--
-- 表的结构 `xy_admin_user_role`
--

CREATE TABLE `xy_admin_user_role` (
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '管理员ID',
  `role_id` bigint(20) UNSIGNED NOT NULL COMMENT '角色ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='管理员-角色关联表';

--
-- 转存表中的数据 `xy_admin_user_role`
--

INSERT INTO `xy_admin_user_role` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1);

-- --------------------------------------------------------

--
-- 表的结构 `xy_captcha`
--

CREATE TABLE `xy_captcha` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '验证码key（MD5）',
  `code` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '验证码code（MD5）',
  `captcha` text COLLATE utf8mb4_general_ci COMMENT '验证码数据（JSON，包含点位坐标等）',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间（unix秒）',
  `expire_time` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '过期时间（unix秒）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='点选验证码';

-- --------------------------------------------------------

--
-- 表的结构 `xy_demo_article`
--

CREATE TABLE `xy_demo_article` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键',
  `category_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '分类ID',
  `title` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `cover` varchar(500) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '封面图',
  `summary` varchar(500) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '摘要',
  `content` text COLLATE utf8mb4_general_ci COMMENT '内容',
  `author` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '作者',
  `views` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '浏览量',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:1=启用,0=禁用',
  `created_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='示例文章';

--
-- 转存表中的数据 `xy_demo_article`
--

INSERT INTO `xy_demo_article` (`id`, `category_id`, `title`, `cover`, `summary`, `content`, `author`, `views`, `sort`, `status`, `created_at`, `updated_at`) VALUES
(1, 3, 'Vue3 组合式API指南', '/attachment/upload/20260117/995f9919-23d3-4ce2-8564-2460e4b1261d.webp', '', '', '张三', 100, 1, 1, 1770653552, 1770868163),
(2, 4, 'GoFrame 入门教程', '/attachment/upload/20260117/995f9919-23d3-4ce2-8564-2460e4b1261d.webp', '', '', '李四', 200, 2, 1, 1770653552, 1770868156),
(3, 5, '家常菜做法', '/attachment/upload/20260210/2c2ddd0e-e4b2-4b76-ba31-1d992de4e0d7.webp', '', '', '王五', 50, 3, 1, 1770653552, 1770868145);

-- --------------------------------------------------------

--
-- 表的结构 `xy_demo_category`
--

CREATE TABLE `xy_demo_category` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键',
  `parent_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '父级ID',
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `icon` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图标',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:1=启用,0=禁用',
  `remark` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `created_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='示例分类';

--
-- 转存表中的数据 `xy_demo_category`
--

INSERT INTO `xy_demo_category` (`id`, `parent_id`, `name`, `icon`, `sort`, `status`, `remark`, `created_at`, `updated_at`) VALUES
(1, 0, '技术', 'ri:dashboard-fill', 1, 1, '技术类文章', 1770653552, 1770812776),
(2, 0, '生活', 'ri:heart-line', 2, 1, '生活类文章', 1770653552, 1770653552),
(3, 1, '前端', 'ri:html5-line', 1, 1, '前端技术', 1770653552, 1770653552),
(4, 1, '后端', 'ri:server-line', 2, 1, '后端技术', 1770653552, 1770653552),
(5, 2, '美食', 'ri:restaurant-line', 1, 1, '美食分享', 1770653552, 1770653552);

-- --------------------------------------------------------

--
-- 表的结构 `xy_member`
--

CREATE TABLE `xy_member` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '会员ID',
  `username` varchar(32) NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(128) NOT NULL DEFAULT '' COMMENT '密码（MD5+salt加密）',
  `salt` varchar(10) NOT NULL DEFAULT '' COMMENT '密码盐',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
  `email` varchar(64) NOT NULL DEFAULT '' COMMENT '邮箱',
  `nickname` varchar(64) NOT NULL DEFAULT '' COMMENT '昵称',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `gender` tinyint(1) NOT NULL DEFAULT '0' COMMENT '性别：0=未知 1=男 2=女',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `money` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '余额',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '积分',
  `level` tinyint(3) UNSIGNED NOT NULL DEFAULT '1' COMMENT '会员等级',
  `group_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会员分组ID',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0=禁用 1=正常',
  `last_login_ip` varchar(50) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `last_login_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'last login time',
  `login_count` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '登录次数',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间',
  `updated_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'deleted time'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员表';

--
-- 转存表中的数据 `xy_member`
--

INSERT INTO `xy_member` (`id`, `username`, `password`, `salt`, `mobile`, `email`, `nickname`, `avatar`, `gender`, `birthday`, `money`, `score`, `level`, `group_id`, `status`, `last_login_ip`, `last_login_at`, `login_count`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'user', '4c0648b0fe19879ee68a5a08899e2296', 'jf8gU6', '', '751300685@qq.com', '751300685', '/attachment/upload/20260212/cc679f09-57e9-4c35-9054-65e4afde8cd3.png', 0, NULL, '0.00', 11, 1, 1, 1, '127.0.0.1', 1770909732, 11, 1770908432, 1770913381, 0);

-- --------------------------------------------------------

--
-- 表的结构 `xy_member_oauth`
--

CREATE TABLE `xy_member_oauth` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键ID',
  `member_id` bigint(20) UNSIGNED NOT NULL COMMENT '关联会员ID',
  `platform` varchar(32) NOT NULL COMMENT '平台标识 wechat_mapp/wechat_oa/qq/alipay等',
  `openid` varchar(128) NOT NULL COMMENT '平台openid',
  `unionid` varchar(128) NOT NULL DEFAULT '' COMMENT 'unionid',
  `session_key` varchar(128) NOT NULL DEFAULT '' COMMENT 'session_key',
  `nickname` varchar(100) NOT NULL DEFAULT '' COMMENT '平台昵称',
  `avatar` varchar(500) NOT NULL DEFAULT '' COMMENT '平台头像',
  `extra` text COMMENT '扩展JSON',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间',
  `updated_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '更新时间',
  `deleted_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'deleted time'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员第三方OAuth认证表';

ALTER TABLE `xy_member_oauth`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_member_oauth_platform_openid` (`platform`,`openid`),
  ADD KEY `idx_member_oauth_member` (`member_id`);

ALTER TABLE `xy_member_oauth`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID';

-- --------------------------------------------------------

--
-- 表的结构 `xy_member_checkin`
--

CREATE TABLE `xy_member_checkin` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会员ID',
  `checkin_date` bigint(20) UNSIGNED DEFAULT NULL COMMENT '签到日期',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '本次获得积分',
  `continuous_days` int(11) NOT NULL DEFAULT '1' COMMENT '连续签到天数',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '签到时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员签到记录';

--
-- 转存表中的数据 `xy_member_checkin`
--

INSERT INTO `xy_member_checkin` (`id`, `member_id`, `checkin_date`, `score`, `continuous_days`, `created_at`) VALUES
(1, 1, NULL, 5, 1, NULL),
(2, 1, 1770910155, 4, 1, 1770910155),
(3, 1, 1770913381, 2, 2, 1770913381);

-- --------------------------------------------------------

--
-- 表的结构 `xy_member_group`
--

CREATE TABLE `xy_member_group` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '分组ID',
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT '分组名称',
  `rules` text COMMENT '权限规则（菜单ID列表，逗号分隔）',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0=禁用 1=正常',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间',
  `updated_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员分组表';

--
-- 转存表中的数据 `xy_member_group`
--

INSERT INTO `xy_member_group` (`id`, `name`, `rules`, `status`, `sort`, `remark`, `created_at`, `updated_at`) VALUES
(1, '普通会员', '*', 1, 0, '默认分组', 1770908749, 1770908749),
(2, 'VIP会员', '1,2,3,4,5', 1, 10, 'VIP用户', 1770908749, 1770908749);

-- --------------------------------------------------------

--
-- 表的结构 `xy_member_login_log`
--

CREATE TABLE `xy_member_login_log` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID',
  `member_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会员ID',
  `username` varchar(32) NOT NULL DEFAULT '' COMMENT '用户名',
  `ip` varchar(50) NOT NULL DEFAULT '' COMMENT '登录IP',
  `user_agent` varchar(512) NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:0=成功,1=失败',
  `message` varchar(255) NOT NULL DEFAULT '' COMMENT '提示信息',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员登录日志表';



-- --------------------------------------------------------

--
-- 表的结构 `xy_member_menu`
--

CREATE TABLE `xy_member_menu` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '菜单ID',
  `pid` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '父级ID',
  `title` varchar(32) NOT NULL DEFAULT '' COMMENT '菜单名称',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '路由名称',
  `path` varchar(128) NOT NULL DEFAULT '' COMMENT '路由路径',
  `component` varchar(255) NOT NULL DEFAULT '' COMMENT 'Vue组件路径（相对于views/frontend/）',
  `icon` varchar(64) NOT NULL DEFAULT '' COMMENT '图标',
  `menu_type` varchar(20) NOT NULL DEFAULT 'tab' COMMENT '菜单打开方式：tab=标签页, link=外链, iframe=内嵌',
  `url` varchar(500) NOT NULL DEFAULT '' COMMENT '外链/iframe地址',
  `no_login_valid` tinyint(1) NOT NULL DEFAULT '0' COMMENT '未登录是否有效：0=否 1=是（公开路由）',
  `extend` varchar(20) NOT NULL DEFAULT 'none' COMMENT '扩展属性：none=无, add_rules_only=仅添加为路由, add_menu_only=仅添加为菜单',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `type` varchar(20) NOT NULL DEFAULT 'menu' COMMENT '类型：route=普通路由, menu_dir=会员中心菜单目录, menu=会员中心菜单项, nav=顶栏菜单项, nav_user_menu=顶栏会员菜单下拉, button=页面按钮',
  `nav_show_children` tinyint(1) NOT NULL DEFAULT '0' COMMENT '顶栏展示子菜单：0否 1是（仅nav）',
  `permission` varchar(64) NOT NULL DEFAULT '' COMMENT '权限标识',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：0=禁用 1=正常',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间',
  `updated_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员菜单表';

--
-- 转存表中的数据 `xy_member_menu`
--

INSERT INTO `xy_member_menu` (`id`, `pid`, `title`, `name`, `path`, `component`, `icon`, `menu_type`, `url`, `no_login_valid`, `extend`, `remark`, `type`, `nav_show_children`, `permission`, `sort`, `status`, `created_at`, `updated_at`) VALUES
(1, 0, '文档', 'docs', '/docs', 'docs/index', 'ri:book-open-line', 'tab', '', 1, 'none', '', 'nav', 0, '', 10, 1, NULL, NULL),
(4, 0, '我的账户', 'account', '/user', '', 'ri:user-line', 'tab', '', 0, 'none', '', 'menu_dir', 0, '', 100, 1, NULL, NULL),
(5, 4, '账户概览', 'overview', '/user/overview', 'member/center', 'ri:home-4-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 101, 1, NULL, NULL),
(6, 4, '每日签到', 'checkin', '/user/checkin', 'member/center', 'ri:calendar-check-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 102, 1, NULL, NULL),
(7, 4, '个人资料', 'profile', '/user/profile', 'member/center', 'ri:user-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 103, 1, NULL, NULL),
(8, 4, '修改密码', 'password', '/user/password', 'member/center', 'ri:shield-keyhole-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 104, 1, NULL, NULL),
(9, 4, '积分记录', 'points', '/user/points', 'member/center', 'ri:copper-coin-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 105, 1, NULL, NULL),
(10, 4, '余额记录', 'balance', '/user/balance', 'member/center', 'ri:wallet-3-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 106, 1, NULL, NULL),
(11, 4, '系统通知', 'notification', '/user/notification', 'member/center', 'ri:notification-3-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 107, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `xy_member_money_log`
--

CREATE TABLE `xy_member_money_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会员ID',
  `money` int(11) NOT NULL DEFAULT '0' COMMENT '变动金额（分，正数=增加，负数=减少）',
  `before` int(11) NOT NULL DEFAULT '0' COMMENT '变动前余额（分）',
  `after` int(11) NOT NULL DEFAULT '0' COMMENT '变动后余额（分）',
  `memo` varchar(255) NOT NULL DEFAULT '' COMMENT '变动说明',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员余额变动日志';

-- --------------------------------------------------------

--
-- 表的结构 `xy_member_notice`
--

CREATE TABLE `xy_member_notice` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '通知标题',
  `content` text COMMENT '通知内容',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'system' COMMENT '通知类型:system=系统通知,announce=公告,feature=功能更新,maintain=维护通知',
  `target` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'all' COMMENT '目标:all=全部会员,group=指定分组',
  `target_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '目标分组ID（target=group时有效）',
  `sender` varchar(50) NOT NULL DEFAULT '系统' COMMENT '发送者',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:0=草稿,1=已发布',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员通知';

--
-- 转存表中的数据 `xy_member_notice`
--

INSERT INTO `xy_member_notice` (`id`, `title`, `content`, `type`, `target`, `target_id`, `sender`, `status`, `created_at`) VALUES
(1, '欢迎使用 XYGo Admin', '感谢您注册成为我们的会员！您可以在会员中心管理个人信息、查看积分和余额变动记录。每天记得签到领取积分哦！', 'system', 'all', 0, '系统', 1, 1770908749),
(2, '每日签到功能上线', '全新的每日签到功能现已上线！每日签到可获得随机积分奖励，连续签到天数越多，奖励越丰厚。快来试试吧！', 'feature', 'all', 0, '系统', 1, 1770908749),
(3, 'test a notify', '<p>这是一个测试通知</p>', 'system', 'all', 0, 'Xygo', 1, 1770910671);

-- --------------------------------------------------------

--
-- 表的结构 `xy_member_notice_read`
--

CREATE TABLE `xy_member_notice_read` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `notice_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '通知ID',
  `member_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会员ID',
  `read_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '阅读时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员通知已读记录';

--
-- 转存表中的数据 `xy_member_notice_read`
--

INSERT INTO `xy_member_notice_read` (`id`, `notice_id`, `member_id`, `read_at`) VALUES
(1, 2, 1, NULL),
(2, 1, 1, NULL),
(3, 3, 1, 1770910685);

-- --------------------------------------------------------

--
-- 表的结构 `xy_member_score_log`
--

CREATE TABLE `xy_member_score_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '会员ID',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '变动积分（正数=增加，负数=减少）',
  `before` int(11) NOT NULL DEFAULT '0' COMMENT '变动前积分',
  `after` int(11) NOT NULL DEFAULT '0' COMMENT '变动后积分',
  `memo` varchar(255) NOT NULL DEFAULT '' COMMENT '变动说明',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员积分变动日志';

--
-- 转存表中的数据 `xy_member_score_log`
--

INSERT INTO `xy_member_score_log` (`id`, `member_id`, `score`, `before`, `after`, `memo`, `created_at`) VALUES
(1, 1, 5, 0, 5, '每日签到奖励', 1770908749),
(2, 1, 4, 5, 9, '每日签到奖励', 1770910155),
(3, 1, 2, 9, 11, '每日签到奖励', 1770913381);

-- --------------------------------------------------------

--
-- 表的结构 `xy_sys_attachment`
--

CREATE TABLE `xy_sys_attachment` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID',
  `topic` varchar(20) NOT NULL DEFAULT '' COMMENT '分组/主题标识',
  `user_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '上传用户ID（预留）',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '物理路径（相对路径）',
  `width` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '宽度',
  `height` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '高度',
  `name` varchar(120) NOT NULL DEFAULT '' COMMENT '原始名称',
  `size` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '大小（字节）',
  `mimetype` varchar(100) NOT NULL DEFAULT '' COMMENT 'MIME类型',
  `quote` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '上传(引用)次数',
  `storage` varchar(50) NOT NULL DEFAULT 'local' COMMENT '存储方式：local=本地',
  `sha1` varchar(40) NOT NULL DEFAULT '' COMMENT 'sha1摘要',
  `create_time` int(10) UNSIGNED NOT NULL COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='附件表';

--
-- 转存表中的数据 `xy_sys_attachment`
--

INSERT INTO `xy_sys_attachment` (`id`, `topic`, `user_id`, `url`, `width`, `height`, `name`, `size`, `mimetype`, `quote`, `storage`, `sha1`, `create_time`, `update_time`) VALUES
(2, 'image', 1, '/attachment/upload/20260117/995f9919-23d3-4ce2-8564-2460e4b1261d.webp', 0, 0, '单独logo (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1768618131, 1768618131),
(3, 'image', 1, '/attachment/upload/20260210/b17249d2-0d9d-496d-a6a5-1c9c2c603459.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770710651, 1770710651),
(4, 'image', 1, '/attachment/upload/20260210/19c3332f-d5db-44f6-bb69-c406e7f4c974.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770711566, 1770711566),
(5, 'image', 1, '/attachment/upload/20260210/5d77559d-27e2-4bec-8ed3-c4ea22f4e032.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770711611, 1770711611),
(6, 'image', 1, '/attachment/upload/20260210/e1469abb-5c58-42a1-b487-4f07d4efcfd2.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770711730, 1770711730),
(7, 'image', 1, '/attachment/upload/20260210/0a27edcc-e96c-4b2e-95f9-b69c772cde82.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770711822, 1770711822),
(8, 'image', 1, '/attachment/upload/20260210/2c2ddd0e-e4b2-4b76-ba31-1d992de4e0d7.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770738480, 1770738480);

-- --------------------------------------------------------

--
-- 表的结构 `xy_sys_config`
--

CREATE TABLE `xy_sys_config` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键',
  `group` varchar(64) NOT NULL DEFAULT '' COMMENT '分组标识，如 basics/mail/oss',
  `group_name` varchar(64) NOT NULL DEFAULT '' COMMENT '分组名称',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '配置项显示名',
  `key` varchar(128) NOT NULL DEFAULT '' COMMENT '配置键（唯一）',
  `value` text COMMENT '配置值（字符串/JSON）',
  `type` varchar(32) NOT NULL DEFAULT 'text' COMMENT '控件类型:text/textarea/number/switch/select/radio/checkbox/json/object/array/color/upload',
  `options` json DEFAULT NULL COMMENT '组件参数/选项 JSON',
  `rules` json DEFAULT NULL COMMENT '校验规则 JSON',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序(大靠后)',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `allow_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '允许删除:0=否,1=是',
  `created_by` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建人',
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL COMMENT '更新人',
  `create_time` int(10) UNSIGNED NOT NULL COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统配置（定义+当前值）';

--
-- 转存表中的数据 `xy_sys_config`
--

INSERT INTO `xy_sys_config` (`id`, `group`, `group_name`, `name`, `key`, `value`, `type`, `options`, `rules`, `sort`, `remark`, `allow_del`, `created_by`, `updated_by`, `create_time`, `update_time`) VALUES
(1, 'basics', '基础设置', '站点名称', 'site_name', 'XYGo Admin', 'text', NULL, '{\"max\": 50, \"required\": true}', 10, '后台标题/LOGO文字', 0, 0, 0, 0, 1770737799),
(2, 'basics', '基础设置', '站点副标题', 'site_subtitle', '下一代 GoFrame 管理后台', 'text', NULL, '{\"max\": 100}', 11, '登录页/浏览器标题副文案', 0, 0, 0, 0, 1770737799),
(3, 'basics', '基础设置', 'ICP备案号', 'site_icp', '粤ICP备000000号', 'text', NULL, '{\"max\": 50}', 20, '展示在页脚的备案号', 0, 0, 0, 0, 1770737799),
(4, 'basics', '基础设置', '站点时区', 'site_timezone', 'Asia/Shanghai', 'select', '{\"options\": [{\"label\": \"上海(Asia/Shanghai)\", \"value\": \"Asia/Shanghai\"}, {\"label\": \"UTC\", \"value\": \"UTC\"}]}', '{\"required\": true}', 30, '影响时间显示/日志默认时区', 0, 0, 0, 0, 1770737799),
(5, 'basics', '基础设置', '是否关闭站点', 'site_closed', '0', 'switch', NULL, '{\"required\": true}', 40, '1=关闭，0=正常访问', 0, 0, 0, 0, 1770737799),
(6, 'mail', '邮件配置', 'SMTP 主机', 'smtp_host', 'smtp.example.com', 'text', NULL, '{\"required\": true}', 10, '邮件服务器地址', 0, 0, 0, 0, 0),
(7, 'mail', '邮件配置', 'SMTP 端口', 'smtp_port', '465', 'number', NULL, '{\"required\": true}', 20, '常见为 25/465/587', 0, 0, 0, 0, 0),
(8, 'mail', '邮件配置', 'SSL 加密', 'smtp_secure', '1', 'switch', NULL, '{\"required\": true}', 30, '1=启用 SSL，0=关闭', 0, 0, 0, 0, 0),
(9, 'mail', '邮件配置', '发件人邮箱', 'smtp_user', 'noreply@example.com', 'text', NULL, '{\"required\": true}', 40, '用作登录用户名/From 地址', 0, 0, 0, 0, 0),
(10, 'mail', '邮件配置', '发件邮箱密码', 'smtp_pass', '', 'text', NULL, '{\"required\": true}', 50, 'SMTP 授权码或密码', 0, 0, 0, 0, 0),
(11, 'oss', '对象存储', '存储驱动', 'oss_driver', 'local', 'select', '{\"options\": [{\"label\": \"本地\", \"value\": \"local\"}, {\"label\": \"阿里云OSS\", \"value\": \"oss\"}, {\"label\": \"七牛云\", \"value\": \"qiniu\"}, {\"label\": \"腾讯云cos\", \"value\": \"cos\"}]}', '{\"required\": true}', 10, '附件实际保存到哪里', 0, 0, 0, 0, 0),
(13, 'security', '安全设置', '禁止访问 IP 列表', 'forbidden_ips', '[\"127.0.0.1\"]', 'textarea', NULL, NULL, 10, '每行一个 IP，支持 CIDR，示例：192.168.0.1 或 10.0.0.0/24', 0, 0, 0, 0, 0),
(14, 'security', '安全设置', '登录失败锁定次数', 'login_fail_max', '5', 'number', NULL, '{\"required\": true}', 20, '超过此次数可触发验证码/锁定策略', 0, 0, 0, 0, 0),
(15, 'security', '安全设置', '登录验证码开关', 'login_captcha', '1', 'switch', NULL, '{\"required\": true}', 30, '1=开启验证码，0=关闭', 0, 0, 0, 0, 0),
(16, 'basics', '基础设置', '站点说明', 'site_description', '这里是站点的简介文案，支持多行文本，用于 SEO 描述等。', 'textarea', NULL, '{\"max\": 300}', 50, '站点的详细介绍，前台可用作描述', 0, 0, 0, 0, 1770737799),
(17, 'basics', '基础设置', '主题主色调', 'theme_color', '#409EFF', 'color', '{\"showAlpha\": false}', NULL, 60, '前端主题主色，后续可用来生成主题变量', 0, 0, 0, 0, 1770737799),
(18, 'basics', '基础设置', '站点 LOGO', 'site_logo', '/attachment/upload/20260117/995f9919-23d3-4ce2-8564-2460e4b1261d.webp', 'image', '{\"tip\": \"建议 200x200 PNG\", \"limit\": 1, \"accept\": \"image/*\"}', NULL, 70, '后台左上角 LOGO 图片', 0, 0, 0, 0, 1770737799),
(19, 'security', '安全设置', '密码强度要求', 'password_level', 'medium', 'radio', '{\"options\": [{\"label\": \"宽松\", \"value\": \"low\"}, {\"label\": \"中等\", \"value\": \"medium\"}, {\"label\": \"严格\", \"value\": \"high\"}]}', '{\"required\": true}', 40, '影响密码最小长度、复杂度校验等', 0, 0, 0, 0, 0),
(20, 'security', '安全设置', '登录防护策略', 'login_protect', '[\"ip_limit\"]', 'checkbox', '{\"options\": [{\"label\": \"限制 IP 白名单\", \"value\": \"ip_limit\"}, {\"label\": \"启用登录验证码\", \"value\": \"captcha\"}, {\"label\": \"限制同账号多地登录\", \"value\": \"multi_login_limit\"}]}', NULL, 50, '多选组合策略，后续中间件可按值启用对应防护', 0, 0, 0, 0, 0),
(23, 'basics', '基础设置', '示例三维数组', 'sample_array_3d', '[{\"name\":\"张三\",\"role\":\"admin\",\"tags\":[\"vue\",\"react\"],\"avatar\":\"https://example.com/avatars/zhangsan.jpg\"},{\"name\":\"李四\",\"role\":\"user\",\"tags\":[\"react\"],\"avatar\":\"https://example.com/avatars/lisi.jpg\"}]', 'array', '{\"fields\": [{\"key\": \"name\", \"type\": \"text\", \"label\": \"姓名\", \"placeholder\": \"请输入姓名\"}, {\"key\": \"role\", \"type\": \"select\", \"label\": \"角色\", \"options\": [{\"label\": \"管理员\", \"value\": \"admin\"}, {\"label\": \"用户\", \"value\": \"user\"}, {\"label\": \"访客\", \"value\": \"guest\"}], \"placeholder\": \"请选择角色\"}, {\"key\": \"tags\", \"type\": \"selects\", \"label\": \"标签\", \"options\": [{\"label\": \"Vue\", \"value\": \"vue\"}, {\"label\": \"React\", \"value\": \"react\"}, {\"label\": \"Angular\", \"value\": \"angular\"}], \"placeholder\": \"请选择标签\"}, {\"key\": \"avatar\", \"type\": \"image\", \"label\": \"头像\", \"maxSize\": 5}]}', NULL, 99, '用于测试多维数组渲染（可在高级 JSON 模式查看）', 0, 0, 0, 0, 1770737799),
(24, 'security', '安全设置', '登录验证码模式', 'login_captcha_mode', 'qrcode', 'select', '{\"options\": [{\"label\": \"短信\", \"value\": \"sms\"}, {\"label\": \"邮箱\", \"value\": \"email\"}, {\"label\": \"二维码\", \"value\": \"qrcode\"}]}', NULL, 120, '单选下拉示例', 0, 0, 0, 0, 0),
(25, 'security', '安全设置', '登录防护策略（多选）', 'login_protect_multi', '[\"ip_limit\",\"captcha\",\"multi_login_limit\"]', 'selects', '{\"options\": [{\"label\": \"限制 IP 白名单\", \"value\": \"ip_limit\"}, {\"label\": \"启用验证码\", \"value\": \"captcha\"}, {\"label\": \"限制同账号多地登录\", \"value\": \"multi_login_limit\"}], \"multiple\": true}', NULL, 130, '多选下拉示例', 0, 0, 0, 0, 0),
(26, 'basics', '基础设置', '站点富文本', 'site_richtext', '<p>测试服务这回可以了吧真的好厉害</p>', 'editor', '{\"mode\": \"default\", \"height\": \"360px\", \"placeholder\": \"请输入站点介绍...\", \"toolbarKeys\": [\"headerSelect\", \"bold\", \"underline\", \"italic\", \"through\", \"color\", \"bgColor\", \"link\", \"bulletedList\", \"numberedList\", \"todo\", \"justifyLeft\", \"justifyCenter\", \"justifyRight\", \"insertTable\", \"uploadImage\", \"codeBlock\", \"undo\", \"redo\"], \"uploadConfig\": {\"maxFileSize\": 3145728, \"maxNumberOfFiles\": 5}}', NULL, 100, '富文本示例，使用 ArtWangEditor', 0, NULL, NULL, 0, 1770737799),
(27, 'basics', '基础设置', '站点富文本', 'site_textedio', '<p>啊啊啊啊</p>', 'editor', '{\"mode\": \"default\", \"height\": \"360px\", \"placeholder\": \"请输入站点介绍...\", \"toolbarKeys\": [\"headerSelect\", \"bold\", \"underline\", \"italic\", \"through\", \"color\", \"bgColor\", \"link\", \"bulletedList\", \"numberedList\", \"todo\", \"justifyLeft\", \"justifyCenter\", \"justifyRight\", \"insertTable\", \"uploadImage\", \"codeBlock\", \"undo\", \"redo\"], \"uploadConfig\": {\"maxFileSize\": 3145728, \"maxNumberOfFiles\": 5}}', NULL, 100, '富文本示例，使用 ArtWangEditor', 0, NULL, NULL, 0, 1770737799),
(28, 'dictionary', '字典配置', '配置分组字典', 'config_group', '[{\"group\":\"basics\",\"groupName\":\"基础设置\",\"icon\":\"ri:settings-3-line\",\"description\":\"系统常规信息配置\",\"sort\":0},{\"group\":\"oss\",\"groupName\":\"对象存储\",\"icon\":\"ri:cloud-line\",\"description\":\"对象存储配置\",\"sort\":10},{\"group\":\"mail\",\"groupName\":\"邮件配置\",\"icon\":\"ri:mail-line\",\"description\":\"邮箱账号信息配置\",\"sort\":20},{\"group\":\"security\",\"groupName\":\"安全设置\",\"icon\":\"ri:shield-line\",\"description\":\"安全相关配置\",\"sort\":30},{\"group\":\"sms\",\"groupName\":\"短信配置\",\"icon\":\"ri:smartphone-line\",\"description\":\"配置短信接口\",\"sort\":40},{\"group\":\"we_mapp\",\"groupName\":\"小程序配置\",\"icon\":\"ri:wechat-fill\",\"description\":\"微信小程序配置\",\"sort\":50},{\"group\":\"we_oa\",\"groupName\":\"公众号配置\",\"icon\":\"ri:wechat-line\",\"description\":\"微信公众号配置\",\"sort\":60}]', 'array', '{\"fields\": [{\"key\": \"group\", \"type\": \"text\", \"label\": \"分组标识\", \"placeholder\": \"如 basics/mail/oss\"}, {\"key\": \"groupName\", \"type\": \"text\", \"label\": \"分组名称\", \"placeholder\": \"显示名称\"}, {\"key\": \"icon\", \"type\": \"text\", \"label\": \"图标\", \"placeholder\": \"如 ri:settings-3-line\"}, {\"key\": \"description\", \"type\": \"text\", \"label\": \"描述\", \"placeholder\": \"分组描述信息\"}, {\"key\": \"sort\", \"min\": 0, \"type\": \"number\", \"label\": \"排序\", \"placeholder\": \"越大越靠后\"}]}', NULL, 10, '配置分组字典（key=group，value=显示名）', 0, NULL, NULL, 0, 1770736665),
(34, 'oss', '对象存储', '阿里云 endpoint', 'oss_aliyun_endpoint', '', 'text', NULL, NULL, 110, '如 oss-cn-hangzhou.aliyuncs.com', 0, NULL, NULL, 0, 0),
(35, 'oss', '对象存储', '阿里云 AccessKeyId', 'oss_aliyun_access_key_id', '', 'text', NULL, NULL, 111, '', 0, NULL, NULL, 0, 0),
(36, 'oss', '对象存储', '阿里云 AccessKeySecret', 'oss_aliyun_access_key_secret', '', 'text', NULL, NULL, 112, '', 0, NULL, NULL, 0, 0),
(37, 'oss', '对象存储', '阿里云 bucket', 'oss_aliyun_bucket', '', 'text', NULL, NULL, 113, '', 0, NULL, NULL, 0, 0),
(38, 'oss', '对象存储', '阿里云 domain', 'oss_aliyun_domain', '', 'text', NULL, NULL, 114, '建议配置为自定义域名/CDN，如 https://static.example.com', 0, NULL, NULL, 0, 0),
(39, 'oss', '对象存储', '阿里云 root', 'oss_aliyun_root', '', 'text', NULL, NULL, 115, '可选，例如 uploads，留空则存根目录', 0, NULL, NULL, 0, 0),
(40, 'oss', '对象存储', '七牛 AccessKey', 'oss_qiniu_access_key', '', 'text', NULL, NULL, 120, '', 0, NULL, NULL, 0, 0),
(41, 'oss', '对象存储', '七牛 SecretKey', 'oss_qiniu_secret_key', '', 'text', NULL, NULL, 121, '', 0, NULL, NULL, 0, 0),
(42, 'oss', '对象存储', '七牛 bucket', 'oss_qiniu_bucket', '', 'text', NULL, NULL, 122, '', 0, NULL, NULL, 0, 0),
(43, 'oss', '对象存储', '七牛 domain', 'oss_qiniu_domain', '', 'text', NULL, NULL, 123, '绑定域名，如 https://img.xxx.com', 0, NULL, NULL, 0, 0),
(44, 'oss', '对象存储', '七牛 root', 'oss_qiniu_root', '', 'text', NULL, NULL, 124, '可选，留空存根目录', 0, NULL, NULL, 0, 0),
(45, 'oss', '对象存储', '七牛 zone', 'oss_qiniu_zone', '', 'text', NULL, NULL, 125, '可选，留空自动；如 z0/z1', 0, NULL, NULL, 0, 0),
(46, 'oss', '对象存储', '七牛 uplink', 'oss_qiniu_uplink', '', 'text', NULL, NULL, 126, '可空', 0, NULL, NULL, 0, 0),
(47, 'oss', '对象存储', 'COS SecretId', 'oss_cos_secret_id', '', 'text', NULL, NULL, 130, '', 0, NULL, NULL, 0, 0),
(48, 'oss', '对象存储', 'COS SecretKey', 'oss_cos_secret_key', '', 'text', NULL, NULL, 131, '', 0, NULL, NULL, 0, 0),
(49, 'oss', '对象存储', 'COS Region', 'oss_cos_region', '', 'text', NULL, NULL, 132, '如 ap-shanghai', 0, NULL, NULL, 0, 0),
(50, 'oss', '对象存储', 'COS bucket', 'oss_cos_bucket', '', 'text', NULL, NULL, 133, '含 AppId，如 xxx-125xxxx', 0, NULL, NULL, 0, 0),
(51, 'oss', '对象存储', 'COS domain', 'oss_cos_domain', '', 'text', NULL, NULL, 134, '可选自定义域名', 0, NULL, NULL, 0, 0),
(52, 'oss', '对象存储', 'COS root', 'oss_cos_root', '', 'text', NULL, NULL, 135, '可选，留空存根目录', 0, NULL, NULL, 0, 0),
(53, 'oss', '对象存储', 'COS schema', 'oss_cos_schema', '', 'text', NULL, NULL, 136, 'http 或 https，默认 https', 0, NULL, NULL, 0, 0),
(54, 'oss', '对象存储', '单文件最大大小', 'upload_max_size', '10mb', 'text', NULL, NULL, 10, '支持 b、kb、mb、gb，例如 10mb', 0, NULL, NULL, 0, 0),
(55, 'oss', '对象存储', '允许的文件后缀', 'upload_allowed_suffixes', 'jpg,png,bmp,jpeg,gif,webp,zip,rar,wav,mp4,mp3,docx', 'text', NULL, NULL, 11, '逗号分隔，小写字母', 0, NULL, NULL, 0, 0),
(56, 'oss', '对象存储', '允许的MIME类型', 'upload_allowed_mime_types', '', 'text', NULL, NULL, 12, '留空表示不限制，例如 image/png,image/jpeg', 0, NULL, NULL, 0, 0),
(57, 'basics', '基础设置', '前台会员中心', 'open_member_center', '1', 'switch', '{\"activeText\": \"\", \"activeValue\": \"1\", \"inactiveText\": \"\", \"inactiveValue\": \"0\"}', NULL, 100, '如关闭则无法登录注册前台会员中心', 0, NULL, NULL, 1770736767, 1770737799),
(58, 'we_mapp', '小程序配置', '微信小程序appid', 'wmapp_appid', '', 'text', '{\"pattern\": \"\", \"maxLength\": 50, \"minLength\": 0, \"placeholder\": \"请输入\"}', NULL, 100, '微信小程序appid', 0, NULL, NULL, 1773624392, 1773624392),
(59, 'we_mapp', '小程序配置', '微信小程序appsecret', 'wmapp_secret', '', 'text', '{\"pattern\": \"\", \"maxLength\": 50, \"minLength\": 0, \"placeholder\": \"请输入\"}', NULL, 100, '', 0, NULL, NULL, 1773624417, 1773624417),
(60, 'we_oa', '公众号配置', '公众号AppID', 'weoa_appid', '', 'text', '{\"pattern\": \"\", \"maxLength\": 50, \"minLength\": 0, \"placeholder\": \"请输入公众号AppID\"}', NULL, 100, '微信公众号AppID', 0, NULL, NULL, 1773624417, 1773624417),
(61, 'we_oa', '公众号配置', '公众号AppSecret', 'weoa_secret', '', 'text', '{\"pattern\": \"\", \"maxLength\": 50, \"minLength\": 0, \"placeholder\": \"请输入公众号AppSecret\"}', NULL, 110, '微信公众号AppSecret', 0, NULL, NULL, 1773624417, 1773624417),
(62, 'we_oa', '公众号配置', '公众号Token', 'weoa_token', '', 'text', '{\"pattern\": \"\", \"maxLength\": 100, \"minLength\": 0, \"placeholder\": \"请输入公众号服务器Token\"}', NULL, 120, '公众号服务器配置Token（用于消息验证）', 0, NULL, NULL, 1773624417, 1773624417);

-- --------------------------------------------------------

--
-- 表的结构 `xy_sys_cron`
--

CREATE TABLE `xy_sys_cron` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '任务ID',
  `group_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '分组ID',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '任务标题',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '任务标识（唯一，对应代码注册名）',
  `params` varchar(1000) NOT NULL DEFAULT '' COMMENT '任务参数（逗号分隔）',
  `pattern` varchar(100) NOT NULL DEFAULT '' COMMENT 'Cron表达式',
  `policy` tinyint(4) NOT NULL DEFAULT '1' COMMENT '策略:1并行,2单例,3单次,4固定次数',
  `count` int(11) NOT NULL DEFAULT '0' COMMENT '固定次数（policy=4时有效）',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `remark` varchar(500) NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态:0禁用,1启用',
  `created_at` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务表';

--
-- 转存表中的数据 `xy_sys_cron`
--

INSERT INTO `xy_sys_cron` (`id`, `group_id`, `title`, `name`, `params`, `pattern`, `policy`, `count`, `sort`, `remark`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, '测试定时任务', 'test', 'hello word', '*/5 * * * * *', 1, 1, 0, '一个测试范例定时任务', 0, 1770718404, 1770718450),
(2, 1, '监测队列状态', 'queue_alert', '5,1', '0 */5 * * * *', 1, 1, 0, '检测队列积压情况', 0, 1770720827, 1770725448);

-- --------------------------------------------------------

--
-- 表的结构 `xy_sys_cron_group`
--

CREATE TABLE `xy_sys_cron_group` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '分组ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '分组名称',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序（越小越靠前）',
  `remark` varchar(500) NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态:0禁用,1启用',
  `created_at` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务分组表';

--
-- 转存表中的数据 `xy_sys_cron_group`
--

INSERT INTO `xy_sys_cron_group` (`id`, `name`, `sort`, `remark`, `status`, `created_at`, `updated_at`) VALUES
(1, '系统任务', 0, '系统内置定时任务', 1, 1770716554, 1770716554),
(2, '业务任务', 10, '业务自定义定时任务', 1, 1770716554, 1770716554);

-- --------------------------------------------------------

--
-- 表的结构 `xy_sys_cron_log`
--

CREATE TABLE `xy_sys_cron_log` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '日志ID',
  `cron_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '任务ID',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '任务标识',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '任务标题',
  `params` varchar(1000) NOT NULL DEFAULT '' COMMENT '执行参数',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态:1成功,2失败',
  `output` text COMMENT '执行输出',
  `err_msg` text COMMENT '错误信息',
  `take_ms` int(11) NOT NULL DEFAULT '0' COMMENT '耗时(毫秒)',
  `created_at` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '执行时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务执行日志表';

--
-- 转存表中的数据 `xy_sys_cron_log`
--

INSERT INTO `xy_sys_cron_log` (`id`, `cron_id`, `name`, `title`, `params`, `status`, `output`, `err_msg`, `take_ms`, `created_at`) VALUES
(1, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:25] hello word', '', 0, 1770718405),
(2, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:30] hello word', '', 0, 1770718410),
(3, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:35] hello word', '', 0, 1770718415),
(4, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:40] hello word', '', 0, 1770718420),
(5, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:45] hello word', '', 0, 1770718425),
(6, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:50] hello word', '', 0, 1770718430),
(7, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:55] hello word', '', 0, 1770718435),
(8, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:14:00] hello word', '', 0, 1770718440),
(9, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:14:05] hello word', '', 0, 1770718445),
(10, 2, 'queue_alert', 'queue_alert', '100,10', 1, 'all queues normal', '', 1, 1770720900),
(11, 2, 'queue_alert', 'queue_alert', '100,10', 1, 'all queues normal', '', 2, 1770721200),
(12, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 3, 1770721426),
(13, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 3, 1770721500),
(14, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 3, 1770721514),
(15, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 4, 1770721520),
(16, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 6, 1770721622),
(17, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 5, 1770721633),
(18, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 3, 1770721649),
(19, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 4, 1770721800),
(20, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 3, 1770722100),
(21, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 3, 1770722400),
(22, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 3, 1770722700),
(23, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 3, 1770723000),
(24, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 2, 1770723300),
(25, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 3, 1770723600),
(26, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 7, 1770723900),
(27, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 5, 1770724200),
(28, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 2, 1770724500),
(29, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 5, 1770724800),
(30, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 3, 1770725100),
(31, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:\n队列 login_log 积压 7 条（阈值 5）\n队列 login_log 死信 2 条（阈值 1）', '', 4, 1770725400);

-- --------------------------------------------------------

--
-- 表的结构 `xy_sys_gen_codes`
--

CREATE TABLE `xy_sys_gen_codes` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键',
  `gen_type` tinyint(3) UNSIGNED NOT NULL DEFAULT '10' COMMENT '生成类型:10=普通列表,11=树表',
  `db_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '数据库名',
  `table_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '数据表名',
  `table_comment` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '表注释(菜单名)',
  `var_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '实体名(PascalCase)',
  `options` json DEFAULT NULL COMMENT '生成选项(JSON)',
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT '2' COMMENT '状态:1=已生成,2=未生成',
  `created_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间戳',
  `updated_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间戳'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='代码生成配置主表';

--
-- 转存表中的数据 `xy_sys_gen_codes`
--

INSERT INTO `xy_sys_gen_codes` (`id`, `gen_type`, `db_name`, `table_name`, `table_comment`, `var_name`, `options`, `status`, `created_at`, `updated_at`) VALUES
(37, 10, 'xygonew', 'xy_member_login_log', '登录日志', 'MemberLoginLog', '{\"menu\": {\"pid\": 143, \"icon\": \"ri:file-list-line\", \"sort\": 100}, \"tree\": {\"pidColumn\": \"parent_id\", \"titleColumn\": \"name\"}, \"autoOps\": [\"genMenuPermissions\", \"runDao\", \"runService\"], \"genType\": 10, \"headOps\": [\"batchDel\", \"export\"], \"genPaths\": {}, \"viewMode\": \"page\", \"apiPrefix\": \"\", \"columnOps\": [\"del\", \"view\", \"check\"]}', 2, 1770873777, 1770873777),
(51, 10, 'xygonew', 'xy_member_money_log', '余额变动日志', 'MemberMoneyLog', '{\"menu\": {\"pid\": 143, \"icon\": \"ri:file-list-line\", \"sort\": 100}, \"tree\": {\"pidColumn\": \"parent_id\", \"titleColumn\": \"name\"}, \"autoOps\": [\"genMenuPermissions\", \"runDao\", \"runService\"], \"genType\": 10, \"headOps\": [\"add\", \"batchDel\", \"export\"], \"genPaths\": {}, \"viewMode\": \"drawer\", \"apiPrefix\": \"\", \"columnOps\": [\"edit\", \"del\", \"view\", \"status\", \"check\"], \"modulePath\": \"member/member-money-log\", \"generatedFiles\": {\"server\": [\"E:\\\\xygoadmin\\\\server\\\\api\\\\admin\\\\admin_member_money_log.go\", \"E:\\\\xygoadmin\\\\server\\\\internal\\\\controller\\\\admin\\\\member_money_log.go\", \"E:\\\\xygoadmin\\\\server\\\\resource\\\\sql\\\\generate\\\\menu_member_money_log.sql\", \"E:\\\\xygoadmin\\\\server\\\\internal\\\\model\\\\input\\\\adminin\\\\member_money_log.go\", \"E:\\\\xygoadmin\\\\server\\\\internal\\\\logic\\\\membermoneylog\\\\member_money_log.go\"], \"frontend\": [\"E:\\\\xygoadmin\\\\newweb\\\\src\\\\api\\\\backend\\\\member\\\\member-money-log.ts\", \"E:\\\\xygoadmin\\\\newweb\\\\src\\\\views\\\\backend\\\\member\\\\member-money-log\\\\index.vue\", \"E:\\\\xygoadmin\\\\newweb\\\\src\\\\views\\\\backend\\\\member\\\\member-money-log\\\\modules\\\\member-money-log-dialog.vue\", \"E:\\\\xygoadmin\\\\newweb\\\\src\\\\views\\\\backend\\\\member\\\\member-money-log\\\\modules\\\\member-money-log-detail-drawer.vue\", \"E:\\\\xygoadmin\\\\newweb\\\\src\\\\views\\\\backend\\\\member\\\\member-money-log\\\\modules\\\\member-money-log-search.vue\"]}}', 1, 1770881561, 1770881606),
(52, 10, 'xygonew', 'xy_member_score_log', '积分变动日志', 'MemberScoreLog', '{\"menu\": {\"pid\": 143, \"icon\": \"ri:file-list-line\", \"sort\": 100}, \"tree\": {\"pidColumn\": \"parent_id\", \"titleColumn\": \"name\"}, \"autoOps\": [\"genMenuPermissions\", \"runDao\", \"runService\"], \"genType\": 10, \"headOps\": [\"add\", \"batchDel\", \"export\"], \"genPaths\": {}, \"viewMode\": \"drawer\", \"apiPrefix\": \"\", \"columnOps\": [\"edit\", \"del\", \"view\", \"status\", \"check\"], \"modulePath\": \"member/member-score-log\", \"generatedFiles\": {\"server\": [\"E:\\\\xygoadmin\\\\server\\\\api\\\\admin\\\\admin_member_score_log.go\", \"E:\\\\xygoadmin\\\\server\\\\internal\\\\controller\\\\admin\\\\member_score_log.go\", \"E:\\\\xygoadmin\\\\server\\\\resource\\\\sql\\\\generate\\\\menu_member_score_log.sql\", \"E:\\\\xygoadmin\\\\server\\\\internal\\\\model\\\\input\\\\adminin\\\\member_score_log.go\", \"E:\\\\xygoadmin\\\\server\\\\internal\\\\logic\\\\memberscorelog\\\\member_score_log.go\"], \"frontend\": [\"E:\\\\xygoadmin\\\\newweb\\\\src\\\\api\\\\backend\\\\member\\\\member-score-log.ts\", \"E:\\\\xygoadmin\\\\newweb\\\\src\\\\views\\\\backend\\\\member\\\\member-score-log\\\\index.vue\", \"E:\\\\xygoadmin\\\\newweb\\\\src\\\\views\\\\backend\\\\member\\\\member-score-log\\\\modules\\\\member-score-log-dialog.vue\", \"E:\\\\xygoadmin\\\\newweb\\\\src\\\\views\\\\backend\\\\member\\\\member-score-log\\\\modules\\\\member-score-log-detail-drawer.vue\", \"E:\\\\xygoadmin\\\\newweb\\\\src\\\\views\\\\backend\\\\member\\\\member-score-log\\\\modules\\\\member-score-log-search.vue\"]}}', 1, 1770881700, 1770894898),
(67, 10, 'xygonew', 'xy_member_notice', '会员通知', 'MemberNotice', '{\"menu\": {\"pid\": 143, \"icon\": \"ri:notification-line\", \"sort\": 100}, \"tree\": {\"pidColumn\": \"parent_id\", \"titleColumn\": \"name\"}, \"autoOps\": [\"genMenuPermissions\", \"runDao\", \"runService\"], \"genType\": 10, \"headOps\": [\"add\", \"batchDel\", \"export\"], \"genPaths\": {}, \"viewMode\": \"drawer\", \"apiPrefix\": \"\", \"columnOps\": [\"edit\", \"del\", \"view\", \"status\", \"check\"]}', 2, 1770904531, 1770904531);

-- --------------------------------------------------------

--
-- 表的结构 `xy_sys_gen_codes_column`
--

CREATE TABLE `xy_sys_gen_codes_column` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键',
  `gen_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '关联gen_codes.id',
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '数据库字段名',
  `go_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Go字段名',
  `ts_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'TS字段名',
  `db_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '数据库类型',
  `go_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Go类型',
  `ts_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'TS类型',
  `comment` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '字段注释',
  `is_pk` tinyint(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否主键:0=否,1=是',
  `is_required` tinyint(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否必填:0=否,1=是',
  `is_list` tinyint(3) UNSIGNED NOT NULL DEFAULT '1' COMMENT '表格列显示:0=否,1=是',
  `is_edit` tinyint(3) UNSIGNED NOT NULL DEFAULT '1' COMMENT '表单编辑显示:0=否,1=是',
  `is_query` tinyint(3) UNSIGNED NOT NULL DEFAULT '0' COMMENT '搜索条件:0=否,1=是',
  `query_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'eq' COMMENT '查询方式:eq/like/between/gt/in',
  `design_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '设计类型(designType)',
  `extra` text COLLATE utf8mb4_general_ci COMMENT '扩展配置JSON(关联表配置/表格属性/表单属性等)',
  `form_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'input' COMMENT '表单组件类型',
  `dict_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '关联字典',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '排序'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='代码生成字段配置表';

--
-- 转存表中的数据 `xy_sys_gen_codes_column`
--

INSERT INTO `xy_sys_gen_codes_column` (`id`, `gen_id`, `name`, `go_name`, `ts_name`, `db_type`, `go_type`, `ts_type`, `comment`, `is_pk`, `is_required`, `is_list`, `is_edit`, `is_query`, `query_type`, `design_type`, `extra`, `form_type`, `dict_type`, `sort`) VALUES
(491, 37, 'id', 'Id', 'id', 'bigint(20) unsigned', 'uint64', 'number', 'ID', 1, 0, 1, 0, 0, 'eq', 'pk', '', 'input', '', 1),
(492, 37, 'member_id', 'MemberId', 'memberId', 'bigint(20) unsigned', 'uint64', 'number', '会员ID', 0, 1, 1, 1, 0, 'eq', 'remoteSelect', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"remote-table\":\"xy_member\",\"remote-pk\":\"id\",\"remote-field\":\"username\",\"relation-fields-config\":\"[{\\\"field\\\":\\\"id\\\",\\\"label\\\":\\\"会员ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"username\\\",\\\"label\\\":\\\"用户名\\\",\\\"inList\\\":true,\\\"inSearch\\\":true,\\\"inExport\\\":true,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"password\\\",\\\"label\\\":\\\"密码（bcrypt加密）\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"mobile\\\",\\\"label\\\":\\\"手机号\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"email\\\",\\\"label\\\":\\\"邮箱\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"nickname\\\",\\\"label\\\":\\\"昵称\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"avatar\\\",\\\"label\\\":\\\"头像\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"gender\\\",\\\"label\\\":\\\"性别\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"birthday\\\",\\\"label\\\":\\\"生日\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"money\\\",\\\"label\\\":\\\"余额\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"score\\\",\\\"label\\\":\\\"积分\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"level\\\",\\\"label\\\":\\\"会员等级\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"group_id\\\",\\\"label\\\":\\\"会员分组ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"status\\\",\\\"label\\\":\\\"状态\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"last_login_ip\\\",\\\"label\\\":\\\"最后登录IP\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"last_login_at\\\",\\\"label\\\":\\\"最后登录时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"login_count\\\",\\\"label\\\":\\\"登录次数\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"created_at\\\",\\\"label\\\":\\\"创建时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"updated_at\\\",\\\"label\\\":\\\"更新时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"deleted_at\\\",\\\"label\\\":\\\"删除时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"}]\",\"relation-fields\":\"username\",\"relation-search-fields\":\"username\",\"relation-export-fields\":\"username\"},\"_tableProps\":{\"render\":\"none\",\"operator\":\"eq\",\"sortable\":\"false\"}}', 'remoteSelect', '', 2),
(493, 37, 'username', 'Username', 'username', 'varchar(32)', 'string', 'string', '用户名', 0, 1, 1, 1, 0, 'like', 'string', '', 'input', '', 3),
(494, 37, 'ip', 'Ip', 'ip', 'varchar(50)', 'string', 'string', '登录IP', 0, 1, 1, 1, 0, 'eq', 'string', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\"},\"_tableProps\":{\"render\":\"tag\",\"operator\":\"like\",\"sortable\":\"false\"}}', 'input', '', 4),
(495, 37, 'user_agent', 'UserAgent', 'userAgent', 'varchar(512)', 'string', 'string', 'User-Agent', 0, 1, 1, 1, 0, 'eq', 'string', '', 'input', '', 5),
(496, 37, 'status', 'Status', 'status', 'tinyint(1)', 'int', 'number', '状态:0=成功,1=失败', 0, 1, 1, 1, 1, 'eq', 'radio', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"dict-options\":\"\"},\"_tableProps\":{\"render\":\"tag\",\"operator\":\"eq\",\"sortable\":\"false\"}}', 'radio', '', 6),
(497, 37, 'message', 'Message', 'message', 'varchar(255)', 'string', 'string', '提示信息', 0, 1, 1, 1, 0, 'eq', 'string', '', 'input', '', 7),
(498, 37, 'created_at', 'CreatedAt', 'createdAt', 'datetime', '*gtime.Time', 'string', '登录时间', 0, 0, 1, 0, 0, 'between', 'datetime', '', 'datetime', '', 8),
(590, 50, 'id', 'Id', 'id', 'bigint(20) unsigned', 'uint64', 'number', '', 1, 0, 1, 0, 0, 'eq', 'pk', '', 'input', '', 1),
(591, 50, 'member_id', 'MemberId', 'memberId', 'bigint(20) unsigned', 'uint64', 'number', '会员ID', 0, 1, 1, 1, 0, 'eq', 'remoteSelect', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"remote-table\":\"xy_member\",\"remote-pk\":\"id\",\"remote-field\":\"nickname\",\"relation-fields-config\":\"[{\\\"field\\\":\\\"id\\\",\\\"label\\\":\\\"会员ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"username\\\",\\\"label\\\":\\\"用户名\\\",\\\"inList\\\":true,\\\"inSearch\\\":true,\\\"inExport\\\":true,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"password\\\",\\\"label\\\":\\\"密码（bcrypt加密）\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"mobile\\\",\\\"label\\\":\\\"手机号\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"email\\\",\\\"label\\\":\\\"邮箱\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"nickname\\\",\\\"label\\\":\\\"昵称\\\",\\\"inList\\\":true,\\\"inSearch\\\":true,\\\"inExport\\\":true,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"avatar\\\",\\\"label\\\":\\\"头像\\\",\\\"inList\\\":true,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"tag\\\"},{\\\"field\\\":\\\"gender\\\",\\\"label\\\":\\\"性别\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"birthday\\\",\\\"label\\\":\\\"生日\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"money\\\",\\\"label\\\":\\\"余额\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"score\\\",\\\"label\\\":\\\"积分\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"level\\\",\\\"label\\\":\\\"会员等级\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"group_id\\\",\\\"label\\\":\\\"会员分组ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"status\\\",\\\"label\\\":\\\"状态\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"last_login_ip\\\",\\\"label\\\":\\\"最后登录IP\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"last_login_at\\\",\\\"label\\\":\\\"最后登录时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"login_count\\\",\\\"label\\\":\\\"登录次数\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"created_at\\\",\\\"label\\\":\\\"创建时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"updated_at\\\",\\\"label\\\":\\\"更新时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"deleted_at\\\",\\\"label\\\":\\\"删除时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"}]\",\"relation-fields\":\"username,nickname,avatar\",\"relation-search-fields\":\"username,nickname\",\"relation-export-fields\":\"username,nickname\"},\"_tableProps\":{\"render\":\"none\",\"operator\":\"eq\",\"sortable\":\"false\"}}', 'remoteSelect', '', 2),
(592, 50, 'money', 'Money', 'money', 'int(11)', 'int', 'number', '变动金额', 0, 1, 1, 1, 0, 'eq', 'number', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"step\":1},\"_tableProps\":{\"render\":\"none\",\"operator\":\"eq\",\"sortable\":\"custom\"}}', 'inputNumber', '', 3),
(593, 50, 'before', 'Before', 'before', 'int(11)', 'int', 'number', '变动前余额（分）', 0, 1, 1, 1, 0, 'eq', 'number', '', 'inputNumber', '', 4),
(594, 50, 'after', 'After', 'after', 'int(11)', 'int', 'number', '变动后余额（分）', 0, 1, 1, 1, 0, 'eq', 'number', '', 'inputNumber', '', 5),
(595, 50, 'memo', 'Memo', 'memo', 'varchar(255)', 'string', 'string', '变动说明', 0, 1, 1, 1, 0, 'eq', 'string', '', 'input', '', 6),
(596, 50, 'created_at', 'CreatedAt', 'createdAt', 'datetime', '*gtime.Time', 'string', '创建时间', 0, 0, 1, 0, 0, 'between', 'datetime', '', 'datetime', '', 7),
(604, 51, 'id', 'Id', 'id', 'bigint(20) unsigned', 'uint64', 'number', '', 1, 0, 1, 0, 0, 'eq', 'pk', '{\"_formProps\":{},\"_tableProps\":{}}', 'input', '', 1),
(605, 51, 'member_id', 'MemberId', 'memberId', 'bigint(20) unsigned', 'uint64', 'number', '会员ID', 0, 1, 1, 1, 0, 'eq', 'remoteSelect', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"remote-table\":\"xy_member\",\"remote-pk\":\"id\",\"remote-field\":\"nickname\",\"relation-fields-config\":\"[{\\\"field\\\":\\\"id\\\",\\\"label\\\":\\\"会员ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"username\\\",\\\"label\\\":\\\"用户名\\\",\\\"inList\\\":true,\\\"inSearch\\\":true,\\\"inExport\\\":true,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"password\\\",\\\"label\\\":\\\"密码（bcrypt加密）\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"mobile\\\",\\\"label\\\":\\\"手机号\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"email\\\",\\\"label\\\":\\\"邮箱\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"nickname\\\",\\\"label\\\":\\\"昵称\\\",\\\"inList\\\":true,\\\"inSearch\\\":true,\\\"inExport\\\":true,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"avatar\\\",\\\"label\\\":\\\"头像\\\",\\\"inList\\\":true,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"image\\\"},{\\\"field\\\":\\\"gender\\\",\\\"label\\\":\\\"性别\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"birthday\\\",\\\"label\\\":\\\"生日\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"money\\\",\\\"label\\\":\\\"余额\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"score\\\",\\\"label\\\":\\\"积分\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"level\\\",\\\"label\\\":\\\"会员等级\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"group_id\\\",\\\"label\\\":\\\"会员分组ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"status\\\",\\\"label\\\":\\\"状态\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"last_login_ip\\\",\\\"label\\\":\\\"最后登录IP\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"last_login_at\\\",\\\"label\\\":\\\"最后登录时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"login_count\\\",\\\"label\\\":\\\"登录次数\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"created_at\\\",\\\"label\\\":\\\"创建时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"updated_at\\\",\\\"label\\\":\\\"更新时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"deleted_at\\\",\\\"label\\\":\\\"删除时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"}]\",\"relation-fields\":\"username,nickname,avatar\",\"relation-search-fields\":\"username,nickname\",\"relation-export-fields\":\"username,nickname\"},\"_tableProps\":{\"render\":\"none\",\"operator\":\"eq\",\"sortable\":\"false\"}}', 'remoteSelect', '', 2),
(606, 51, 'money', 'Money', 'money', 'int(11)', 'int', 'number', '变动金额', 0, 1, 1, 1, 1, 'between', 'number', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"step\":1},\"_tableProps\":{\"render\":\"none\",\"operator\":\"eq\",\"sortable\":\"custom\"}}', 'inputNumber', '', 3),
(607, 51, 'before', 'Before', 'before', 'int(11)', 'int', 'number', '变动前余额（分）', 0, 1, 1, 1, 0, 'eq', 'number', '{\"_formProps\":{},\"_tableProps\":{}}', 'inputNumber', '', 4),
(608, 51, 'after', 'After', 'after', 'int(11)', 'int', 'number', '变动后余额（分）', 0, 1, 1, 1, 0, 'eq', 'number', '{\"_formProps\":{},\"_tableProps\":{}}', 'inputNumber', '', 5),
(609, 51, 'memo', 'Memo', 'memo', 'varchar(255)', 'string', 'string', '变动说明', 0, 1, 1, 1, 0, 'eq', 'string', '{\"_formProps\":{},\"_tableProps\":{}}', 'input', '', 6),
(610, 51, 'created_at', 'CreatedAt', 'createdAt', 'datetime', '*gtime.Time', 'string', '创建时间', 0, 0, 1, 0, 0, 'between', 'datetime', '{\"_formProps\":{},\"_tableProps\":{}}', 'datetime', '', 7),
(653, 52, 'id', 'Id', 'id', 'bigint(20) unsigned', 'uint64', 'number', '', 1, 0, 1, 0, 0, 'eq', 'pk', '{\"_formProps\":{},\"_tableProps\":{}}', 'input', '', 1),
(654, 52, 'member_id', 'MemberId', 'memberId', 'bigint(20) unsigned', 'uint64', 'number', '会员ID', 0, 1, 1, 1, 0, 'eq', 'remoteSelect', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"remote-table\":\"xy_member\",\"remote-pk\":\"id\",\"remote-field\":\"nickname\",\"relation-fields-config\":\"[{\\\"field\\\":\\\"id\\\",\\\"label\\\":\\\"会员ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"username\\\",\\\"label\\\":\\\"用户名\\\",\\\"inList\\\":true,\\\"inSearch\\\":true,\\\"inExport\\\":true,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"password\\\",\\\"label\\\":\\\"密码（bcrypt加密）\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"mobile\\\",\\\"label\\\":\\\"手机号\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"email\\\",\\\"label\\\":\\\"邮箱\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"nickname\\\",\\\"label\\\":\\\"昵称\\\",\\\"inList\\\":true,\\\"inSearch\\\":true,\\\"inExport\\\":true,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"avatar\\\",\\\"label\\\":\\\"头像\\\",\\\"inList\\\":true,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"image\\\"},{\\\"field\\\":\\\"gender\\\",\\\"label\\\":\\\"性别\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"birthday\\\",\\\"label\\\":\\\"生日\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"money\\\",\\\"label\\\":\\\"余额\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"score\\\",\\\"label\\\":\\\"积分\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"level\\\",\\\"label\\\":\\\"会员等级\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"group_id\\\",\\\"label\\\":\\\"会员分组ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"status\\\",\\\"label\\\":\\\"状态\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"last_login_ip\\\",\\\"label\\\":\\\"最后登录IP\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"last_login_at\\\",\\\"label\\\":\\\"最后登录时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"login_count\\\",\\\"label\\\":\\\"登录次数\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"created_at\\\",\\\"label\\\":\\\"创建时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"updated_at\\\",\\\"label\\\":\\\"更新时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"deleted_at\\\",\\\"label\\\":\\\"删除时间\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"}]\",\"relation-fields\":\"username,nickname,avatar\",\"relation-search-fields\":\"username,nickname\",\"relation-export-fields\":\"username,nickname\"},\"_tableProps\":{\"render\":\"none\",\"operator\":\"eq\",\"sortable\":\"false\"}}', 'remoteSelect', '', 2),
(655, 52, 'score', 'Score', 'score', 'int(11)', 'int', 'number', '变动积分', 0, 1, 1, 1, 1, 'between', 'number', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"step\":1},\"_tableProps\":{\"render\":\"none\",\"operator\":\"eq\",\"sortable\":\"custom\"}}', 'inputNumber', '', 3),
(656, 52, 'before', 'Before', 'before', 'int(11)', 'int', 'number', '变动前积分', 0, 1, 1, 1, 0, 'eq', 'number', '{\"_formProps\":{},\"_tableProps\":{}}', 'inputNumber', '', 4),
(657, 52, 'after', 'After', 'after', 'int(11)', 'int', 'number', '变动后积分', 0, 1, 1, 1, 0, 'eq', 'number', '{\"_formProps\":{},\"_tableProps\":{}}', 'inputNumber', '', 5),
(658, 52, 'memo', 'Memo', 'memo', 'varchar(255)', 'string', 'string', '变动说明', 0, 1, 1, 1, 0, 'eq', 'string', '{\"_formProps\":{},\"_tableProps\":{}}', 'input', '', 6),
(659, 52, 'created_at', 'CreatedAt', 'createdAt', 'datetime', '*gtime.Time', 'string', '创建时间', 0, 0, 1, 0, 0, 'between', 'datetime', '{\"_formProps\":{},\"_tableProps\":{}}', 'datetime', '', 7),
(802, 67, 'id', 'Id', 'id', 'bigint(20) unsigned', 'uint64', 'number', '', 1, 0, 1, 0, 0, 'eq', 'pk', '', 'input', '', 1),
(803, 67, 'title', 'Title', 'title', 'varchar(255)', 'string', 'string', '通知标题', 0, 1, 1, 1, 1, 'like', 'string', '', 'input', '', 2),
(804, 67, 'content', 'Content', 'content', 'text', 'string', 'string', '通知内容', 0, 0, 0, 1, 0, 'eq', 'editor', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\"},\"_tableProps\":{\"render\":\"none\",\"operator\":\"false\",\"sortable\":\"false\"}}', 'richEditor', '', 3),
(805, 67, 'type', 'Type', 'type', 'varchar(20)', 'string', 'string', '通知类型', 0, 1, 1, 1, 1, 'eq', 'select', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"dict-options\":\"system=系统通知,announce=公告,feature=功能更新,maintain=维护通知\"},\"_tableProps\":{\"render\":\"tag\",\"operator\":\"eq\",\"sortable\":\"false\"}}', 'select', '', 4),
(806, 67, 'target', 'Target', 'target', 'varchar(20)', 'string', 'string', '目标', 0, 1, 1, 1, 0, 'eq', 'radio', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"dict-options\":\"all=全部会员,group=指定分组\"},\"_tableProps\":{\"render\":\"tag\",\"operator\":\"eq\",\"sortable\":\"false\"}}', 'radio', '', 5),
(807, 67, 'target_id', 'TargetId', 'targetId', 'bigint(20) unsigned', 'uint64', 'number', '目标分组ID', 0, 1, 1, 1, 0, 'eq', 'remoteSelect', '{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"remote-table\":\"xy_member_group\",\"remote-pk\":\"id\",\"remote-field\":\"name\",\"relation-fields-config\":\"[]\",\"relation-fields\":\"\",\"relation-search-fields\":\"\",\"relation-export-fields\":\"\"},\"_tableProps\":{\"render\":\"none\",\"operator\":\"eq\",\"sortable\":\"false\"}}', 'remoteSelect', '', 6),
(808, 67, 'sender', 'Sender', 'sender', 'varchar(50)', 'string', 'string', '发送者', 0, 1, 1, 1, 0, 'eq', 'string', '', 'input', '', 7),
(809, 67, 'status', 'Status', 'status', 'tinyint(1)', 'int', 'number', '状态', 0, 1, 1, 1, 1, 'eq', 'radio', '{\"_formProps\":{\"dict-options\":\"0=草稿,1=已发布\",\"validator\":[],\"validatorMsg\":\"\"},\"_tableProps\":{\"render\":\"tag\",\"operator\":\"eq\",\"sortable\":\"false\"}}', 'radio', '', 8),
(810, 67, 'created_at', 'CreatedAt', 'createdAt', 'datetime', '*gtime.Time', 'string', '创建时间', 0, 0, 1, 0, 0, 'between', 'datetime', '', 'datetime', '', 9);

-- --------------------------------------------------------

--
-- 表的结构 `xy_test_category`
--

CREATE TABLE `xy_test_category` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `parent_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '鐖剁骇ID',
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `icon` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图标',
  `image` varchar(500) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类图片',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:0=禁用,1=启用',
  `remark` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间',
  `updated_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='测试分类表';

--
-- 转存表中的数据 `xy_test_category`
--

INSERT INTO `xy_test_category` (`id`, `parent_id`, `name`, `icon`, `image`, `sort`, `status`, `remark`, `created_at`, `updated_at`) VALUES
(1, 0, '电子产品', 'ri:computer-line', '', 1, 1, '电子数码类', NULL, NULL),
(2, 0, '服装鞋帽', 'ri:t-shirt-line', '', 2, 1, '服饰类', NULL, NULL),
(3, 0, '食品饮料', 'ri:cup-line', '', 3, 1, '食品类', NULL, NULL),
(4, 1, '手机', 'ri:smartphone-line', '', 1, 1, '智能手机', NULL, NULL),
(5, 1, '电脑', 'ri:macbook-line', '', 2, 1, '笔记本/台式机', NULL, NULL),
(6, 1, '平板', 'ri:tablet-line', '', 3, 1, '平板电脑', NULL, NULL),
(7, 2, '男装', '', '', 1, 1, '', NULL, NULL),
(8, 2, '女装', '', '', 2, 1, '', NULL, NULL),
(9, 2, '鞋靴', '', '', 3, 0, '暂时下架', NULL, NULL),
(10, 4, 'iPhone', '', '', 1, 1, 'Apple手机', NULL, NULL),
(11, 4, 'Android', '', '', 2, 1, '安卓手机', NULL, NULL),
(12, 5, '游戏本', '', '', 1, 1, '', NULL, NULL),
(13, 5, '轻薄本', '', '', 2, 1, '', NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `xy_test_code`
--

CREATE TABLE `xy_test_code` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键',
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `member_id` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '关联ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='测试生成';

--
-- 转存表中的数据 `xy_test_code`
--

INSERT INTO `xy_test_code` (`id`, `name`, `member_id`) VALUES
(1, 'test', 1);

-- --------------------------------------------------------

--
-- 表的结构 `xy_test_codec`
--

CREATE TABLE `xy_test_codec` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '主键',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态:0=关闭,1=开启',
  `create_time` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='测试手动创建';

-- --------------------------------------------------------

--
-- 表的结构 `xy_test_order`
--

CREATE TABLE `xy_test_order` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '卖家ID',
  `apply_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '买家ID',
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态:0=待处理,1=已完成,2=已取消',
  `memo` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `created_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '创建时间',
  `updated_at` bigint(20) UNSIGNED DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='测试订单表';

--
-- 转存表中的数据 `xy_test_order`
--

INSERT INTO `xy_test_order` (`id`, `member_id`, `apply_id`, `amount`, `status`, `memo`, `created_at`, `updated_at`) VALUES
(1, 1, 2, '199.90', 1, '测试订单A-已完成', NULL, NULL),
(2, 2, 1, '55.00', 0, '测试订单B-待处理', NULL, NULL),
(3, 1, 3, '320.50', 2, '测试订单C-已取消', NULL, NULL),
(4, 3, 2, '88.80', 1, '测试订单D-已完成', NULL, NULL),
(5, 2, 3, '1200.00', 0, '大额订单E-待处理', NULL, NULL);

--
-- 转储表的索引
--

--
-- 表的索引 `xy_admin_chat_message`
--
ALTER TABLE `xy_admin_chat_message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_session_id` (`session_id`),
  ADD KEY `idx_sender_id` (`sender_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 表的索引 `xy_admin_chat_session`
--
ALTER TABLE `xy_admin_chat_session`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_creator_id` (`creator_id`),
  ADD KEY `idx_last_message_time` (`last_message_time`);

--
-- 表的索引 `xy_admin_chat_session_member`
--
ALTER TABLE `xy_admin_chat_session_member`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_session_user` (`session_id`,`user_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_session_id` (`session_id`);

--
-- 表的索引 `xy_admin_dept`
--
ALTER TABLE `xy_admin_dept`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `xy_admin_dept_closure`
--
ALTER TABLE `xy_admin_dept_closure`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ancestor` (`ancestor`),
  ADD KEY `idx_descendant` (`descendant`);

--
-- 表的索引 `xy_admin_field_perm`
--
ALTER TABLE `xy_admin_field_perm`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_role_resource_field` (`role_id`,`resource`,`field_name`),
  ADD KEY `idx_role_id` (`role_id`),
  ADD KEY `idx_resource` (`resource`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `xy_admin_login_log`
--
ALTER TABLE `xy_admin_login_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 表的索引 `xy_admin_menu`
--
ALTER TABLE `xy_admin_menu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_parent_id` (`parent_id`),
  ADD KEY `idx_type` (`type`);

--
-- 表的索引 `xy_admin_notice`
--
ALTER TABLE `xy_admin_notice`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_receiver` (`receiver_id`),
  ADD KEY `idx_created` (`created_at`);

--
-- 表的索引 `xy_admin_notice_read`
--
ALTER TABLE `xy_admin_notice_read`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_notice_user` (`notice_id`,`user_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- 表的索引 `xy_admin_operation_log`
--
ALTER TABLE `xy_admin_operation_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_module` (`module`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 表的索引 `xy_admin_post`
--
ALTER TABLE `xy_admin_post`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_code` (`code`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_by` (`created_by`);

--
-- 表的索引 `xy_admin_role`
--
ALTER TABLE `xy_admin_role`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_role_key` (`key`);

--
-- 表的索引 `xy_admin_role_menu`
--
ALTER TABLE `xy_admin_role_menu`
  ADD PRIMARY KEY (`role_id`,`menu_id`),
  ADD KEY `idx_menu_id` (`menu_id`);

--
-- 表的索引 `xy_admin_user`
--
ALTER TABLE `xy_admin_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_username` (`username`),
  ADD KEY `idx_dept_id` (`dept_id`),
  ADD KEY `idx_pid` (`pid`);

--
-- 表的索引 `xy_admin_user_post`
--
ALTER TABLE `xy_admin_user_post`
  ADD PRIMARY KEY (`user_id`,`post_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_post_id` (`post_id`);

--
-- 表的索引 `xy_admin_user_role`
--
ALTER TABLE `xy_admin_user_role`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `idx_role_id` (`role_id`);

--
-- 表的索引 `xy_captcha`
--
ALTER TABLE `xy_captcha`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_key` (`key`);

--
-- 表的索引 `xy_demo_article`
--
ALTER TABLE `xy_demo_article`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`category_id`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `xy_demo_category`
--
ALTER TABLE `xy_demo_category`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_parent` (`parent_id`);

--
-- 表的索引 `xy_member`
--
ALTER TABLE `xy_member`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_username` (`username`),
  ADD UNIQUE KEY `uk_mobile` (`mobile`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_group_id` (`group_id`);

--
-- 表的索引 `xy_member_checkin`
--
ALTER TABLE `xy_member_checkin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_member_date` (`member_id`,`checkin_date`),
  ADD KEY `idx_member_id` (`member_id`);

--
-- 表的索引 `xy_member_group`
--
ALTER TABLE `xy_member_group`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `xy_member_login_log`
--
ALTER TABLE `xy_member_login_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_member_id` (`member_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 表的索引 `xy_member_menu`
--
ALTER TABLE `xy_member_menu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pid` (`pid`);

--
-- 表的索引 `xy_member_money_log`
--
ALTER TABLE `xy_member_money_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_member_id` (`member_id`);

--
-- 表的索引 `xy_member_notice`
--
ALTER TABLE `xy_member_notice`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status_created` (`status`,`created_at`);

--
-- 表的索引 `xy_member_notice_read`
--
ALTER TABLE `xy_member_notice_read`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_notice_member` (`notice_id`,`member_id`),
  ADD KEY `idx_member_id` (`member_id`);

--
-- 表的索引 `xy_member_score_log`
--
ALTER TABLE `xy_member_score_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_member_id` (`member_id`);

--
-- 表的索引 `xy_sys_attachment`
--
ALTER TABLE `xy_sys_attachment`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `xy_sys_config`
--
ALTER TABLE `xy_sys_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_config_key` (`key`),
  ADD KEY `idx_group_sort` (`group`,`sort`);

--
-- 表的索引 `xy_sys_cron`
--
ALTER TABLE `xy_sys_cron`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_name` (`name`),
  ADD KEY `idx_group_id` (`group_id`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `xy_sys_cron_group`
--
ALTER TABLE `xy_sys_cron_group`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `xy_sys_cron_log`
--
ALTER TABLE `xy_sys_cron_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cron_id` (`cron_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 表的索引 `xy_sys_gen_codes`
--
ALTER TABLE `xy_sys_gen_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_table` (`db_name`,`table_name`);

--
-- 表的索引 `xy_sys_gen_codes_column`
--
ALTER TABLE `xy_sys_gen_codes_column`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_gen_id` (`gen_id`);

--
-- 表的索引 `xy_test_category`
--
ALTER TABLE `xy_test_category`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `xy_test_code`
--
ALTER TABLE `xy_test_code`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `xy_test_codec`
--
ALTER TABLE `xy_test_codec`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `xy_test_order`
--
ALTER TABLE `xy_test_order`
  ADD PRIMARY KEY (`id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `xy_admin_chat_message`
--
ALTER TABLE `xy_admin_chat_message`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '消息ID', AUTO_INCREMENT=24;

--
-- 使用表AUTO_INCREMENT `xy_admin_chat_session`
--
ALTER TABLE `xy_admin_chat_session`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '会话ID', AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `xy_admin_chat_session_member`
--
ALTER TABLE `xy_admin_chat_session_member`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=11;

--
-- 使用表AUTO_INCREMENT `xy_admin_dept`
--
ALTER TABLE `xy_admin_dept`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '部门ID', AUTO_INCREMENT=9;

--
-- 使用表AUTO_INCREMENT `xy_admin_dept_closure`
--
ALTER TABLE `xy_admin_dept_closure`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID', AUTO_INCREMENT=20;

--
-- 使用表AUTO_INCREMENT `xy_admin_field_perm`
--
ALTER TABLE `xy_admin_field_perm`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键';

--
-- 使用表AUTO_INCREMENT `xy_admin_login_log`
--
ALTER TABLE `xy_admin_login_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID', AUTO_INCREMENT=70;

--
-- 使用表AUTO_INCREMENT `xy_admin_menu`
--
ALTER TABLE `xy_admin_menu`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '菜单ID', AUTO_INCREMENT=630;

--
-- 使用表AUTO_INCREMENT `xy_admin_notice`
--
ALTER TABLE `xy_admin_notice`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `xy_admin_notice_read`
--
ALTER TABLE `xy_admin_notice_read`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `xy_admin_operation_log`
--
ALTER TABLE `xy_admin_operation_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID', AUTO_INCREMENT=922;

--
-- 使用表AUTO_INCREMENT `xy_admin_post`
--
ALTER TABLE `xy_admin_post`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '岗位ID', AUTO_INCREMENT=8;

--
-- 使用表AUTO_INCREMENT `xy_admin_role`
--
ALTER TABLE `xy_admin_role`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '角色ID', AUTO_INCREMENT=6;

--
-- 使用表AUTO_INCREMENT `xy_admin_user`
--
ALTER TABLE `xy_admin_user`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '管理员ID', AUTO_INCREMENT=5;

--
-- 使用表AUTO_INCREMENT `xy_captcha`
--
ALTER TABLE `xy_captcha`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- 使用表AUTO_INCREMENT `xy_demo_article`
--
ALTER TABLE `xy_demo_article`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `xy_demo_category`
--
ALTER TABLE `xy_demo_category`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=6;

--
-- 使用表AUTO_INCREMENT `xy_member`
--
ALTER TABLE `xy_member`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '会员ID', AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `xy_member_checkin`
--
ALTER TABLE `xy_member_checkin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `xy_member_group`
--
ALTER TABLE `xy_member_group`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '分组ID', AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `xy_member_login_log`
--
ALTER TABLE `xy_member_login_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID', AUTO_INCREMENT=20;

--
-- 使用表AUTO_INCREMENT `xy_member_menu`
--
ALTER TABLE `xy_member_menu`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '菜单ID', AUTO_INCREMENT=12;

--
-- 使用表AUTO_INCREMENT `xy_member_money_log`
--
ALTER TABLE `xy_member_money_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `xy_member_notice`
--
ALTER TABLE `xy_member_notice`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `xy_member_notice_read`
--
ALTER TABLE `xy_member_notice_read`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `xy_member_score_log`
--
ALTER TABLE `xy_member_score_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `xy_sys_attachment`
--
ALTER TABLE `xy_sys_attachment`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID', AUTO_INCREMENT=9;

--
-- 使用表AUTO_INCREMENT `xy_sys_config`
--
ALTER TABLE `xy_sys_config`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=58;

--
-- 使用表AUTO_INCREMENT `xy_sys_cron`
--
ALTER TABLE `xy_sys_cron`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '任务ID', AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `xy_sys_cron_group`
--
ALTER TABLE `xy_sys_cron_group`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '分组ID', AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `xy_sys_cron_log`
--
ALTER TABLE `xy_sys_cron_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志ID', AUTO_INCREMENT=32;

--
-- 使用表AUTO_INCREMENT `xy_sys_gen_codes`
--
ALTER TABLE `xy_sys_gen_codes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=69;

--
-- 使用表AUTO_INCREMENT `xy_sys_gen_codes_column`
--
ALTER TABLE `xy_sys_gen_codes_column`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=817;

--
-- 使用表AUTO_INCREMENT `xy_test_category`
--
ALTER TABLE `xy_test_category`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- 使用表AUTO_INCREMENT `xy_test_code`
--
ALTER TABLE `xy_test_code`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `xy_test_codec`
--
ALTER TABLE `xy_test_codec`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键';

--
-- 使用表AUTO_INCREMENT `xy_test_order`
--
ALTER TABLE `xy_test_order`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

-- --------------------------------------------------------
--
-- 表的结构 `xy_cms_doc_category` — 文档分类（树形）
--

CREATE TABLE `xy_cms_doc_category` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '分类ID',
  `pid` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '父分类ID(0=顶级)',
  `title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `icon` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图标',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序(越大越靠前)',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:1=正常,2=禁用',
  `remark` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `created_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文档分类表';

-- --------------------------------------------------------
--
-- 表的结构 `xy_cms_doc` — 文档内容
--

CREATE TABLE `xy_cms_doc` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT '文档ID',
  `category_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '分类ID',
  `title` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文档标题',
  `slug` varchar(200) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'URL标识(唯一)',
  `cover` varchar(500) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '封面图',
  `summary` varchar(500) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '摘要',
  `content` longtext COLLATE utf8mb4_general_ci COMMENT '文档内容(Markdown)',
  `author` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '作者',
  `views` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '浏览量',
  `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序(越大越靠前)',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态:1=已发布,2=草稿,3=下架',
  `is_top` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否置顶:0=否,1=是',
  `tags` varchar(500) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签(JSON数组)',
  `created_by` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `updated_by` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `created_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  `deleted_at` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '删除时间(软删除)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文档内容表';

--
-- 索引 `xy_cms_doc_category`
--
ALTER TABLE `xy_cms_doc_category`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pid` (`pid`),
  ADD KEY `idx_status_sort` (`status`, `sort`);

--
-- 索引 `xy_cms_doc`
--
ALTER TABLE `xy_cms_doc`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_slug` (`slug`),
  ADD KEY `idx_category` (`category_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_sort` (`sort`),
  ADD KEY `idx_created` (`created_at`),
  ADD KEY `idx_deleted` (`deleted_at`);

--
-- 使用表AUTO_INCREMENT `xy_cms_doc_category`
--
ALTER TABLE `xy_cms_doc_category`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '分类ID';

--
-- 使用表AUTO_INCREMENT `xy_cms_doc`
--
ALTER TABLE `xy_cms_doc`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '文档ID';

COMMIT;

-- ============================================================
-- xy_migration: 数据库迁移版本记录
-- ============================================================
CREATE TABLE IF NOT EXISTS `xy_migration` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `version` varchar(32) NOT NULL,
  `name` varchar(128) NOT NULL DEFAULT '',
  `executed_at` bigint NOT NULL DEFAULT 0,
  `checksum` varchar(64) NOT NULL DEFAULT '',
  `success` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_version` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据库迁移记录';

-- ============================================================
-- xy_addon: 扩展安装记录
-- ============================================================
CREATE TABLE IF NOT EXISTS `xy_addon` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `version` varchar(32) NOT NULL DEFAULT '',
  `title` varchar(128) NOT NULL DEFAULT '',
  `status` tinyint NOT NULL DEFAULT 1,
  `installed_at` bigint NOT NULL DEFAULT 0,
  `uninstalled_at` bigint NOT NULL DEFAULT 0,
  `file_list` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='扩展安装记录';

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
