--
-- PostgreSQL database dump
--



-- Dumped from database version 15.14
-- Dumped by pg_dump version 15.16 (Debian 15.16-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: xygonew; Type: SCHEMA; Schema: -; Owner: -
--

-- schema removed, using public


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: xy_admin_chat_message; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_chat_message (
    id bigint NOT NULL,
    session_id bigint DEFAULT 0 NOT NULL,
    sender_id bigint DEFAULT 0 NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    content text NOT NULL,
    created_at integer DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_admin_chat_message; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_chat_message IS '聊天消息表';


--
-- Name: COLUMN xy_admin_chat_message.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_message.id IS '消息ID';


--
-- Name: COLUMN xy_admin_chat_message.session_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_message.session_id IS '会话ID';


--
-- Name: COLUMN xy_admin_chat_message.sender_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_message.sender_id IS '发送者ID';


--
-- Name: COLUMN xy_admin_chat_message.type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_message.type IS '消息类型:1=文字,2=图片,3=系统消息';


--
-- Name: COLUMN xy_admin_chat_message.content; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_message.content IS '消息内容(图片时存URL)';


--
-- Name: COLUMN xy_admin_chat_message.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_message.created_at IS '发送时间';


--
-- Name: xy_admin_chat_message_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_chat_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_chat_message_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_chat_message_id_seq OWNED BY public.xy_admin_chat_message.id;


--
-- Name: xy_admin_chat_session; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_chat_session (
    id bigint NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    avatar character varying(255) DEFAULT ''::character varying NOT NULL,
    creator_id bigint DEFAULT 0 NOT NULL,
    last_message character varying(500) DEFAULT ''::character varying NOT NULL,
    last_message_time integer DEFAULT 0 NOT NULL,
    member_count integer DEFAULT 0 NOT NULL,
    created_at integer DEFAULT 0 NOT NULL,
    updated_at integer DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_admin_chat_session; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_chat_session IS '聊天会话表';


--
-- Name: COLUMN xy_admin_chat_session.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session.id IS '会话ID';


--
-- Name: COLUMN xy_admin_chat_session.type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session.type IS '类型:1=单聊,2=群聊';


--
-- Name: COLUMN xy_admin_chat_session.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session.name IS '群名称(单聊为空)';


--
-- Name: COLUMN xy_admin_chat_session.avatar; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session.avatar IS '群头像';


--
-- Name: COLUMN xy_admin_chat_session.creator_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session.creator_id IS '创建者ID';


--
-- Name: COLUMN xy_admin_chat_session.last_message; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session.last_message IS '最后消息预览';


--
-- Name: COLUMN xy_admin_chat_session.last_message_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session.last_message_time IS '最后消息时间戳';


--
-- Name: COLUMN xy_admin_chat_session.member_count; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session.member_count IS '成员数';


--
-- Name: COLUMN xy_admin_chat_session.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session.created_at IS '创建时间';


--
-- Name: COLUMN xy_admin_chat_session.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session.updated_at IS '更新时间';


--
-- Name: xy_admin_chat_session_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_chat_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_chat_session_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_chat_session_id_seq OWNED BY public.xy_admin_chat_session.id;


--
-- Name: xy_admin_chat_session_member; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_chat_session_member (
    id bigint NOT NULL,
    session_id bigint DEFAULT 0 NOT NULL,
    user_id bigint DEFAULT 0 NOT NULL,
    role smallint DEFAULT 1 NOT NULL,
    unread_count integer DEFAULT 0 NOT NULL,
    last_read_msg_id bigint DEFAULT 0 NOT NULL,
    is_muted smallint DEFAULT 0 NOT NULL,
    is_deleted smallint DEFAULT 0 NOT NULL,
    joined_at integer DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_admin_chat_session_member; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_chat_session_member IS '聊天会话成员表';


--
-- Name: COLUMN xy_admin_chat_session_member.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session_member.id IS '主键';


--
-- Name: COLUMN xy_admin_chat_session_member.session_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session_member.session_id IS '会话ID';


--
-- Name: COLUMN xy_admin_chat_session_member.user_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session_member.user_id IS '用户ID';


--
-- Name: COLUMN xy_admin_chat_session_member.role; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session_member.role IS '角色:1=成员,2=管理员,3=群主';


--
-- Name: COLUMN xy_admin_chat_session_member.unread_count; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session_member.unread_count IS '未读消息数';


--
-- Name: COLUMN xy_admin_chat_session_member.last_read_msg_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session_member.last_read_msg_id IS '最后已读消息ID';


--
-- Name: COLUMN xy_admin_chat_session_member.is_muted; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session_member.is_muted IS '是否免打扰:0=否,1=是';


--
-- Name: COLUMN xy_admin_chat_session_member.is_deleted; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session_member.is_deleted IS '是否删除会话:0=否,1=是';


--
-- Name: COLUMN xy_admin_chat_session_member.joined_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_chat_session_member.joined_at IS '加入时间';


--
-- Name: xy_admin_chat_session_member_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_chat_session_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_chat_session_member_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_chat_session_member_id_seq OWNED BY public.xy_admin_chat_session_member.id;


--
-- Name: xy_admin_dept; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_dept (
    id bigint NOT NULL,
    parent_id bigint DEFAULT 0 NOT NULL,
    name character varying(50) NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    remark character varying(500),
    create_by bigint DEFAULT 0,
    create_time bigint,
    update_time bigint
);


--
-- Name: TABLE xy_admin_dept; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_dept IS '部门管理';


--
-- Name: COLUMN xy_admin_dept.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept.id IS '部门ID';


--
-- Name: COLUMN xy_admin_dept.parent_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept.parent_id IS '上级部门ID';


--
-- Name: COLUMN xy_admin_dept.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept.name IS '部门名称';


--
-- Name: COLUMN xy_admin_dept.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept.sort IS '排序';


--
-- Name: COLUMN xy_admin_dept.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept.status IS '状态:0禁用,1启用';


--
-- Name: COLUMN xy_admin_dept.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept.remark IS '备注';


--
-- Name: COLUMN xy_admin_dept.create_by; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept.create_by IS '创建人';


--
-- Name: COLUMN xy_admin_dept.create_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept.create_time IS '创建时间';


--
-- Name: COLUMN xy_admin_dept.update_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept.update_time IS '更新时间';


--
-- Name: xy_admin_dept_closure; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_dept_closure (
    id bigint NOT NULL,
    ancestor bigint NOT NULL,
    descendant bigint NOT NULL,
    level integer DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_admin_dept_closure; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_dept_closure IS '部门闭包表';


--
-- Name: COLUMN xy_admin_dept_closure.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept_closure.id IS 'ID';


--
-- Name: COLUMN xy_admin_dept_closure.ancestor; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept_closure.ancestor IS '祖先部门ID';


--
-- Name: COLUMN xy_admin_dept_closure.descendant; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept_closure.descendant IS '后代部门ID';


--
-- Name: COLUMN xy_admin_dept_closure.level; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_dept_closure.level IS '层级深度';


--
-- Name: xy_admin_dept_closure_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_dept_closure_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_dept_closure_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_dept_closure_id_seq OWNED BY public.xy_admin_dept_closure.id;


--
-- Name: xy_admin_dept_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_dept_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_dept_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_dept_id_seq OWNED BY public.xy_admin_dept.id;


--
-- Name: xy_admin_field_perm; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_field_perm (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    module character varying(50) DEFAULT ''::character varying NOT NULL,
    resource character varying(100) NOT NULL,
    field_name character varying(100) NOT NULL,
    field_label character varying(100),
    perm_type smallint DEFAULT 2 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    remark character varying(255),
    create_time bigint NOT NULL,
    update_time bigint NOT NULL
);


--
-- Name: TABLE xy_admin_field_perm; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_field_perm IS '字段权限配置表';


--
-- Name: COLUMN xy_admin_field_perm.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_field_perm.id IS '主键';


--
-- Name: COLUMN xy_admin_field_perm.role_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_field_perm.role_id IS '角色ID';


--
-- Name: COLUMN xy_admin_field_perm.module; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_field_perm.module IS '模块名称（如：system、org）';


--
-- Name: COLUMN xy_admin_field_perm.resource; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_field_perm.resource IS '资源标识（表名或页面标识，如：admin_user、user_list）';


--
-- Name: COLUMN xy_admin_field_perm.field_name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_field_perm.field_name IS '字段名称（如：mobile、salary）';


--
-- Name: COLUMN xy_admin_field_perm.field_label; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_field_perm.field_label IS '字段显示名称（用于界面展示）';


--
-- Name: COLUMN xy_admin_field_perm.perm_type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_field_perm.perm_type IS '权限类型：0=不可见，1=只读，2=可编辑';


--
-- Name: COLUMN xy_admin_field_perm.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_field_perm.status IS '状态：0=禁用，1=启用';


--
-- Name: COLUMN xy_admin_field_perm.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_field_perm.remark IS '备注';


--
-- Name: COLUMN xy_admin_field_perm.create_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_field_perm.create_time IS '创建时间';


--
-- Name: COLUMN xy_admin_field_perm.update_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_field_perm.update_time IS '更新时间';


--
-- Name: xy_admin_field_perm_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_field_perm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_field_perm_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_field_perm_id_seq OWNED BY public.xy_admin_field_perm.id;


--
-- Name: xy_admin_login_log; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_login_log (
    id bigint NOT NULL,
    user_id bigint DEFAULT 0 NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    ip character varying(64) DEFAULT ''::character varying NOT NULL,
    location character varying(255) DEFAULT ''::character varying NOT NULL,
    user_agent character varying(500) DEFAULT ''::character varying NOT NULL,
    browser character varying(128) DEFAULT ''::character varying NOT NULL,
    os character varying(128) DEFAULT ''::character varying NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    message character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at bigint
);


--
-- Name: TABLE xy_admin_login_log; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_login_log IS '管理员登录日志';


--
-- Name: COLUMN xy_admin_login_log.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_login_log.id IS '日志ID';


--
-- Name: COLUMN xy_admin_login_log.user_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_login_log.user_id IS '管理员ID（0=未知用户）';


--
-- Name: COLUMN xy_admin_login_log.username; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_login_log.username IS '登录账号';


--
-- Name: COLUMN xy_admin_login_log.ip; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_login_log.ip IS '登录IP';


--
-- Name: COLUMN xy_admin_login_log.location; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_login_log.location IS '登录地点';


--
-- Name: COLUMN xy_admin_login_log.user_agent; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_login_log.user_agent IS 'User-Agent';


--
-- Name: COLUMN xy_admin_login_log.browser; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_login_log.browser IS '浏览器';


--
-- Name: COLUMN xy_admin_login_log.os; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_login_log.os IS '操作系统';


--
-- Name: COLUMN xy_admin_login_log.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_login_log.status IS '状态：0=失败 1=成功';


--
-- Name: COLUMN xy_admin_login_log.message; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_login_log.message IS '提示消息';


--
-- Name: COLUMN xy_admin_login_log.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_login_log.created_at IS '创建时间';


--
-- Name: xy_admin_login_log_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_login_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_login_log_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_login_log_id_seq OWNED BY public.xy_admin_login_log.id;


--
-- Name: xy_admin_menu; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_menu (
    id bigint NOT NULL,
    parent_id bigint DEFAULT 0 NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    title character varying(50) NOT NULL,
    name character varying(50) DEFAULT ''::character varying NOT NULL,
    path character varying(100) DEFAULT ''::character varying NOT NULL,
    component character varying(100) DEFAULT ''::character varying NOT NULL,
    resource character varying(50) DEFAULT ''::character varying,
    icon character varying(50) DEFAULT ''::character varying NOT NULL,
    hidden smallint DEFAULT 0 NOT NULL,
    keep_alive smallint DEFAULT 0 NOT NULL,
    redirect character varying(100) DEFAULT ''::character varying NOT NULL,
    frame_src character varying(255) DEFAULT ''::character varying NOT NULL,
    perms text,
    is_frame smallint DEFAULT 0 NOT NULL,
    affix smallint DEFAULT 0 NOT NULL,
    show_badge smallint DEFAULT 0 NOT NULL,
    badge_text character varying(50) DEFAULT ''::character varying NOT NULL,
    active_path character varying(255) DEFAULT ''::character varying NOT NULL,
    hide_tab smallint DEFAULT 0 NOT NULL,
    is_full_page smallint DEFAULT 0 NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    remark character varying(255) DEFAULT ''::character varying NOT NULL,
    created_by bigint DEFAULT 0 NOT NULL,
    updated_by bigint DEFAULT 0 NOT NULL,
    create_time integer NOT NULL,
    update_time integer NOT NULL
);


--
-- Name: TABLE xy_admin_menu; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_menu IS '后台菜单/权限表';


--
-- Name: COLUMN xy_admin_menu.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.id IS '菜单ID';


--
-- Name: COLUMN xy_admin_menu.parent_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.parent_id IS '上级菜单ID';


--
-- Name: COLUMN xy_admin_menu.type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.type IS '类型:1=目录,2=菜单,3=按钮';


--
-- Name: COLUMN xy_admin_menu.title; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.title IS '标题(菜单名称)';


--
-- Name: COLUMN xy_admin_menu.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.name IS '前端路由name';


--
-- Name: COLUMN xy_admin_menu.path; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.path IS '路由路径';


--
-- Name: COLUMN xy_admin_menu.component; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.component IS '前端组件路径';


--
-- Name: COLUMN xy_admin_menu.resource; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.resource IS '关联的数据资源（表名，用于字段权限）';


--
-- Name: COLUMN xy_admin_menu.icon; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.icon IS '图标';


--
-- Name: COLUMN xy_admin_menu.hidden; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.hidden IS '是否隐藏:0=否,1=是';


--
-- Name: COLUMN xy_admin_menu.keep_alive; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.keep_alive IS '是否缓存:0=否,1=是';


--
-- Name: COLUMN xy_admin_menu.redirect; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.redirect IS '重定向地址';


--
-- Name: COLUMN xy_admin_menu.frame_src; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.frame_src IS '内嵌iframe地址';


--
-- Name: COLUMN xy_admin_menu.perms; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.perms IS '权限点列表(JSON数组,内容为 METHOD+PATH 字符串)';


--
-- Name: COLUMN xy_admin_menu.is_frame; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.is_frame IS '是否内嵌:0=否,1=是';


--
-- Name: COLUMN xy_admin_menu.affix; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.affix IS '是否固定标签:0=否,1=是';


--
-- Name: COLUMN xy_admin_menu.show_badge; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.show_badge IS '是否显示徽章:0=否,1=是';


--
-- Name: COLUMN xy_admin_menu.badge_text; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.badge_text IS '徽章文本';


--
-- Name: COLUMN xy_admin_menu.active_path; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.active_path IS '激活高亮路径';


--
-- Name: COLUMN xy_admin_menu.hide_tab; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.hide_tab IS '是否隐藏标签:0=否,1=是';


--
-- Name: COLUMN xy_admin_menu.is_full_page; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.is_full_page IS '是否全屏页面:0=否,1=是';


--
-- Name: COLUMN xy_admin_menu.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.sort IS '排序(越大越靠后)';


--
-- Name: COLUMN xy_admin_menu.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.status IS '状态:0=禁用,1=启用';


--
-- Name: COLUMN xy_admin_menu.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.remark IS '备注';


--
-- Name: COLUMN xy_admin_menu.created_by; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.created_by IS '创建人ID';


--
-- Name: COLUMN xy_admin_menu.updated_by; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.updated_by IS '更新人ID';


--
-- Name: COLUMN xy_admin_menu.create_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.create_time IS '创建时间';


--
-- Name: COLUMN xy_admin_menu.update_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_menu.update_time IS '更新时间';


--
-- Name: xy_admin_menu_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_menu_id_seq OWNED BY public.xy_admin_menu.id;


--
-- Name: xy_admin_notice; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_notice (
    id bigint NOT NULL,
    title character varying(200) DEFAULT ''::character varying NOT NULL,
    type smallint DEFAULT 1 NOT NULL,
    content text,
    tag character varying(50) DEFAULT ''::character varying NOT NULL,
    sender_id bigint DEFAULT 0 NOT NULL,
    receiver_id bigint DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    remark character varying(255) DEFAULT ''::character varying NOT NULL,
    read_count integer DEFAULT 0 NOT NULL,
    created_at bigint DEFAULT 0 NOT NULL,
    updated_at bigint DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_admin_notice; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_notice IS '通知消息表';


--
-- Name: COLUMN xy_admin_notice.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.id IS '主键';


--
-- Name: COLUMN xy_admin_notice.title; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.title IS '标题';


--
-- Name: COLUMN xy_admin_notice.type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.type IS '类型:1=通知,2=公告,3=私信';


--
-- Name: COLUMN xy_admin_notice.content; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.content IS '内容(HTML)';


--
-- Name: COLUMN xy_admin_notice.tag; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.tag IS '标签(info/success/warning/danger)';


--
-- Name: COLUMN xy_admin_notice.sender_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.sender_id IS '发送人ID(0=系统)';


--
-- Name: COLUMN xy_admin_notice.receiver_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.receiver_id IS '接收人ID(0=全员)';


--
-- Name: COLUMN xy_admin_notice.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.status IS '状态:1=正常,2=关闭';


--
-- Name: COLUMN xy_admin_notice.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.sort IS '排序';


--
-- Name: COLUMN xy_admin_notice.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.remark IS '备注';


--
-- Name: COLUMN xy_admin_notice.read_count; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.read_count IS '已读人数';


--
-- Name: COLUMN xy_admin_notice.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.created_at IS '创建时间';


--
-- Name: COLUMN xy_admin_notice.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice.updated_at IS '更新时间';


--
-- Name: xy_admin_notice_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_notice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_notice_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_notice_id_seq OWNED BY public.xy_admin_notice.id;


--
-- Name: xy_admin_notice_read; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_notice_read (
    id bigint NOT NULL,
    notice_id bigint NOT NULL,
    user_id bigint NOT NULL,
    read_at bigint DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_admin_notice_read; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_notice_read IS '通知已读记录表';


--
-- Name: COLUMN xy_admin_notice_read.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice_read.id IS '主键';


--
-- Name: COLUMN xy_admin_notice_read.notice_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice_read.notice_id IS '通知ID';


--
-- Name: COLUMN xy_admin_notice_read.user_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice_read.user_id IS '用户ID';


--
-- Name: COLUMN xy_admin_notice_read.read_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_notice_read.read_at IS '阅读时间';


--
-- Name: xy_admin_notice_read_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_notice_read_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_notice_read_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_notice_read_id_seq OWNED BY public.xy_admin_notice_read.id;


--
-- Name: xy_admin_operation_log; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_operation_log (
    id bigint NOT NULL,
    user_id bigint DEFAULT 0 NOT NULL,
    username character varying(64) DEFAULT ''::character varying NOT NULL,
    module character varying(64) DEFAULT ''::character varying NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    method character varying(10) DEFAULT ''::character varying NOT NULL,
    url character varying(500) DEFAULT ''::character varying NOT NULL,
    ip character varying(64) DEFAULT ''::character varying NOT NULL,
    location character varying(255) DEFAULT ''::character varying NOT NULL,
    user_agent character varying(500) DEFAULT ''::character varying NOT NULL,
    request_body text,
    response_body text,
    error_message character varying(1000) DEFAULT ''::character varying NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    elapsed integer DEFAULT 0 NOT NULL,
    created_at bigint
);


--
-- Name: TABLE xy_admin_operation_log; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_operation_log IS '管理员操作日志';


--
-- Name: COLUMN xy_admin_operation_log.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.id IS '日志ID';


--
-- Name: COLUMN xy_admin_operation_log.user_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.user_id IS '操作人ID';


--
-- Name: COLUMN xy_admin_operation_log.username; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.username IS '操作人账号';


--
-- Name: COLUMN xy_admin_operation_log.module; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.module IS '模块名称（如：用户管理、角色管理）';


--
-- Name: COLUMN xy_admin_operation_log.title; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.title IS '操作标题/接口描述';


--
-- Name: COLUMN xy_admin_operation_log.method; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.method IS 'HTTP方法（GET/POST/PUT/DELETE）';


--
-- Name: COLUMN xy_admin_operation_log.url; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.url IS '请求URL';


--
-- Name: COLUMN xy_admin_operation_log.ip; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.ip IS '操作IP';


--
-- Name: COLUMN xy_admin_operation_log.location; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.location IS '操作地点';


--
-- Name: COLUMN xy_admin_operation_log.user_agent; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.user_agent IS 'User-Agent';


--
-- Name: COLUMN xy_admin_operation_log.request_body; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.request_body IS '请求参数（JSON）';


--
-- Name: COLUMN xy_admin_operation_log.response_body; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.response_body IS '响应结果（JSON，可选截断存储）';


--
-- Name: COLUMN xy_admin_operation_log.error_message; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.error_message IS '错误信息';


--
-- Name: COLUMN xy_admin_operation_log.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.status IS '状态：0=失败 1=成功';


--
-- Name: COLUMN xy_admin_operation_log.elapsed; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.elapsed IS '耗时（毫秒）';


--
-- Name: COLUMN xy_admin_operation_log.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_operation_log.created_at IS '创建时间';


--
-- Name: xy_admin_operation_log_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_operation_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_operation_log_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_operation_log_id_seq OWNED BY public.xy_admin_operation_log.id;


--
-- Name: xy_admin_post; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_post (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(50) NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    remark character varying(500) DEFAULT ''::character varying,
    created_by bigint DEFAULT 0,
    updated_by bigint DEFAULT 0,
    create_time bigint DEFAULT 0,
    update_time bigint DEFAULT 0
);


--
-- Name: TABLE xy_admin_post; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_post IS '岗位表';


--
-- Name: COLUMN xy_admin_post.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_post.id IS '岗位ID';


--
-- Name: COLUMN xy_admin_post.code; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_post.code IS '岗位编码';


--
-- Name: COLUMN xy_admin_post.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_post.name IS '岗位名称';


--
-- Name: COLUMN xy_admin_post.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_post.sort IS '排序(越小越靠前)';


--
-- Name: COLUMN xy_admin_post.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_post.status IS '状态:0=禁用,1=启用';


--
-- Name: COLUMN xy_admin_post.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_post.remark IS '备注';


--
-- Name: COLUMN xy_admin_post.created_by; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_post.created_by IS '创建人ID';


--
-- Name: COLUMN xy_admin_post.updated_by; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_post.updated_by IS '更新人ID';


--
-- Name: COLUMN xy_admin_post.create_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_post.create_time IS '创建时间';


--
-- Name: COLUMN xy_admin_post.update_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_post.update_time IS '更新时间';


--
-- Name: xy_admin_post_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_post_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_post_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_post_id_seq OWNED BY public.xy_admin_post.id;


--
-- Name: xy_admin_role; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_role (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    key character varying(50) NOT NULL,
    data_scope smallint DEFAULT 0 NOT NULL,
    custom_depts text,
    pid bigint DEFAULT 0 NOT NULL,
    level bigint DEFAULT '1'::bigint NOT NULL,
    tree character varying(255) DEFAULT '0'::character varying NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    remark character varying(255) DEFAULT ''::character varying NOT NULL,
    created_by bigint DEFAULT 0 NOT NULL,
    updated_by bigint DEFAULT 0 NOT NULL,
    create_time bigint NOT NULL,
    update_time bigint NOT NULL
);


--
-- Name: TABLE xy_admin_role; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_role IS '后台角色表';


--
-- Name: COLUMN xy_admin_role.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.id IS '角色ID';


--
-- Name: COLUMN xy_admin_role.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.name IS '角色名称';


--
-- Name: COLUMN xy_admin_role.key; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.key IS '角色标识(英文唯一)';


--
-- Name: COLUMN xy_admin_role.data_scope; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.data_scope IS '数据范围:0=全部,1=本部门,2=本部门及子,3=仅本人,4=自定义部门';


--
-- Name: COLUMN xy_admin_role.custom_depts; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.custom_depts IS '自定义数据范围部门ID列表(JSON数组)';


--
-- Name: COLUMN xy_admin_role.pid; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.pid IS '上级角色ID';


--
-- Name: COLUMN xy_admin_role.level; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.level IS '关系树等级（根为1）';


--
-- Name: COLUMN xy_admin_role.tree; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.tree IS '关系树路径，如 0,1,3';


--
-- Name: COLUMN xy_admin_role.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.sort IS '排序（越小越靠前）';


--
-- Name: COLUMN xy_admin_role.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.status IS '状态:0=禁用,1=启用';


--
-- Name: COLUMN xy_admin_role.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.remark IS '备注';


--
-- Name: COLUMN xy_admin_role.created_by; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.created_by IS '创建人ID';


--
-- Name: COLUMN xy_admin_role.updated_by; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.updated_by IS '更新人ID';


--
-- Name: COLUMN xy_admin_role.create_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.create_time IS '创建时间';


--
-- Name: COLUMN xy_admin_role.update_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role.update_time IS '更新时间';


--
-- Name: xy_admin_role_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_role_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_role_id_seq OWNED BY public.xy_admin_role.id;


--
-- Name: xy_admin_role_menu; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_role_menu (
    role_id bigint NOT NULL,
    menu_id bigint NOT NULL
);


--
-- Name: TABLE xy_admin_role_menu; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_role_menu IS '角色-菜单关联表';


--
-- Name: COLUMN xy_admin_role_menu.role_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role_menu.role_id IS '角色ID';


--
-- Name: COLUMN xy_admin_role_menu.menu_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_role_menu.menu_id IS '菜单ID';


--
-- Name: xy_admin_user; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_user (
    id bigint NOT NULL,
    username character varying(50) NOT NULL,
    nickname character varying(50) DEFAULT ''::character varying NOT NULL,
    real_name character varying(50),
    password character varying(255) NOT NULL,
    gender smallint DEFAULT 0 NOT NULL,
    salt character varying(50) DEFAULT ''::character varying NOT NULL,
    mobile character varying(20) DEFAULT ''::character varying NOT NULL,
    address character varying(255),
    remark character varying(500),
    email character varying(100) DEFAULT ''::character varying NOT NULL,
    avatar character varying(255) DEFAULT ''::character varying NOT NULL,
    dept_id bigint DEFAULT 0 NOT NULL,
    pid bigint DEFAULT 0,
    is_super smallint DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    last_login_at bigint,
    last_login_ip character varying(50) DEFAULT ''::character varying NOT NULL,
    created_by bigint DEFAULT 0 NOT NULL,
    updated_by bigint DEFAULT 0 NOT NULL,
    create_time bigint,
    update_time bigint
);


--
-- Name: TABLE xy_admin_user; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_user IS '后台管理员表';


--
-- Name: COLUMN xy_admin_user.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.id IS '管理员ID';


--
-- Name: COLUMN xy_admin_user.username; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.username IS '登录账号';


--
-- Name: COLUMN xy_admin_user.nickname; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.nickname IS '昵称';


--
-- Name: COLUMN xy_admin_user.real_name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.real_name IS '真实姓名';


--
-- Name: COLUMN xy_admin_user.password; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.password IS '密码哈希';


--
-- Name: COLUMN xy_admin_user.gender; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.gender IS '性别0保密 1男 2女';


--
-- Name: COLUMN xy_admin_user.salt; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.salt IS '密码盐';


--
-- Name: COLUMN xy_admin_user.mobile; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.mobile IS '手机号';


--
-- Name: COLUMN xy_admin_user.address; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.address IS '地址';


--
-- Name: COLUMN xy_admin_user.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.remark IS '个人简介';


--
-- Name: COLUMN xy_admin_user.email; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.email IS '邮箱';


--
-- Name: COLUMN xy_admin_user.avatar; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.avatar IS '头像';


--
-- Name: COLUMN xy_admin_user.dept_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.dept_id IS '部门ID';


--
-- Name: COLUMN xy_admin_user.pid; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.pid IS '上级用户ID（直属上级）';


--
-- Name: COLUMN xy_admin_user.is_super; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.is_super IS '是否超管:0=否,1=是';


--
-- Name: COLUMN xy_admin_user.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.status IS '状态:0=禁用,1=启用';


--
-- Name: COLUMN xy_admin_user.last_login_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.last_login_at IS 'last login time';


--
-- Name: COLUMN xy_admin_user.last_login_ip; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.last_login_ip IS '最后登录IP';


--
-- Name: COLUMN xy_admin_user.created_by; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.created_by IS '创建人ID';


--
-- Name: COLUMN xy_admin_user.updated_by; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.updated_by IS '更新人ID';


--
-- Name: COLUMN xy_admin_user.create_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.create_time IS '创建时间';


--
-- Name: COLUMN xy_admin_user.update_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user.update_time IS '更新时间';


--
-- Name: xy_admin_user_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_admin_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_admin_user_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_admin_user_id_seq OWNED BY public.xy_admin_user.id;


--
-- Name: xy_admin_user_post; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_user_post (
    user_id bigint NOT NULL,
    post_id bigint NOT NULL
);


--
-- Name: TABLE xy_admin_user_post; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_user_post IS '用户岗位关联表';


--
-- Name: COLUMN xy_admin_user_post.user_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user_post.user_id IS '用户ID';


--
-- Name: COLUMN xy_admin_user_post.post_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user_post.post_id IS '岗位ID';


--
-- Name: xy_admin_user_role; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_admin_user_role (
    user_id bigint NOT NULL,
    role_id bigint NOT NULL
);


--
-- Name: TABLE xy_admin_user_role; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_admin_user_role IS '管理员-角色关联表';


--
-- Name: COLUMN xy_admin_user_role.user_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user_role.user_id IS '管理员ID';


--
-- Name: COLUMN xy_admin_user_role.role_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_admin_user_role.role_id IS '角色ID';


--
-- Name: xy_captcha; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_captcha (
    id bigint NOT NULL,
    key character varying(64) DEFAULT ''::character varying NOT NULL,
    code character varying(64) DEFAULT ''::character varying NOT NULL,
    captcha text,
    create_time bigint DEFAULT 0 NOT NULL,
    expire_time bigint DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_captcha; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_captcha IS '点选验证码';


--
-- Name: COLUMN xy_captcha.key; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_captcha.key IS '验证码key（MD5）';


--
-- Name: COLUMN xy_captcha.code; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_captcha.code IS '验证码code（MD5）';


--
-- Name: COLUMN xy_captcha.captcha; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_captcha.captcha IS '验证码数据（JSON，包含点位坐标等）';


--
-- Name: COLUMN xy_captcha.create_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_captcha.create_time IS '创建时间（unix秒）';


--
-- Name: COLUMN xy_captcha.expire_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_captcha.expire_time IS '过期时间（unix秒）';


--
-- Name: xy_captcha_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_captcha_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_captcha_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_captcha_id_seq OWNED BY public.xy_captcha.id;


--
-- Name: xy_demo_article; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_demo_article (
    id bigint NOT NULL,
    category_id integer DEFAULT 0 NOT NULL,
    title character varying(200) DEFAULT ''::character varying NOT NULL,
    cover character varying(500) DEFAULT ''::character varying NOT NULL,
    summary character varying(500) DEFAULT ''::character varying NOT NULL,
    content text,
    author character varying(50) DEFAULT ''::character varying NOT NULL,
    views integer DEFAULT 0 NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_at bigint DEFAULT 0 NOT NULL,
    updated_at bigint DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_demo_article; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_demo_article IS '示例文章';


--
-- Name: COLUMN xy_demo_article.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.id IS '主键';


--
-- Name: COLUMN xy_demo_article.category_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.category_id IS '分类ID';


--
-- Name: COLUMN xy_demo_article.title; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.title IS '标题';


--
-- Name: COLUMN xy_demo_article.cover; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.cover IS '封面图';


--
-- Name: COLUMN xy_demo_article.summary; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.summary IS '摘要';


--
-- Name: COLUMN xy_demo_article.content; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.content IS '内容';


--
-- Name: COLUMN xy_demo_article.author; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.author IS '作者';


--
-- Name: COLUMN xy_demo_article.views; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.views IS '浏览量';


--
-- Name: COLUMN xy_demo_article.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.sort IS '排序';


--
-- Name: COLUMN xy_demo_article.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.status IS '状态:1=启用,0=禁用';


--
-- Name: COLUMN xy_demo_article.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.created_at IS '创建时间';


--
-- Name: COLUMN xy_demo_article.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_article.updated_at IS '更新时间';


--
-- Name: xy_demo_article_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_demo_article_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_demo_article_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_demo_article_id_seq OWNED BY public.xy_demo_article.id;


--
-- Name: xy_demo_category; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_demo_category (
    id bigint NOT NULL,
    parent_id bigint DEFAULT 0 NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    icon character varying(100) DEFAULT ''::character varying NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    remark character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at bigint DEFAULT 0 NOT NULL,
    updated_at bigint DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_demo_category; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_demo_category IS '示例分类';


--
-- Name: COLUMN xy_demo_category.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_category.id IS '主键';


--
-- Name: COLUMN xy_demo_category.parent_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_category.parent_id IS '父级ID';


--
-- Name: COLUMN xy_demo_category.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_category.name IS '分类名称';


--
-- Name: COLUMN xy_demo_category.icon; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_category.icon IS '图标';


--
-- Name: COLUMN xy_demo_category.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_category.sort IS '排序';


--
-- Name: COLUMN xy_demo_category.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_category.status IS '状态:1=启用,0=禁用';


--
-- Name: COLUMN xy_demo_category.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_category.remark IS '备注';


--
-- Name: COLUMN xy_demo_category.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_category.created_at IS '创建时间';


--
-- Name: COLUMN xy_demo_category.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_demo_category.updated_at IS '更新时间';


--
-- Name: xy_demo_category_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_demo_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_demo_category_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_demo_category_id_seq OWNED BY public.xy_demo_category.id;


--
-- Name: xy_member; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_member (
    id bigint NOT NULL,
    username character varying(32) DEFAULT ''::character varying NOT NULL,
    password character varying(128) DEFAULT ''::character varying NOT NULL,
    salt character varying(10) DEFAULT ''::character varying NOT NULL,
    mobile character varying(20) DEFAULT ''::character varying NOT NULL,
    email character varying(64) DEFAULT ''::character varying NOT NULL,
    nickname character varying(64) DEFAULT ''::character varying NOT NULL,
    avatar character varying(255) DEFAULT ''::character varying NOT NULL,
    gender smallint DEFAULT 0 NOT NULL,
    birthday date,
    money numeric(10,2) DEFAULT 0.00 NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    level smallint DEFAULT 1 NOT NULL,
    group_id bigint DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    last_login_ip character varying(50) DEFAULT ''::character varying NOT NULL,
    last_login_at bigint,
    login_count integer DEFAULT 0 NOT NULL,
    created_at bigint,
    updated_at bigint,
    deleted_at bigint DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_member; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_member IS '会员表';


--
-- Name: COLUMN xy_member.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.id IS '会员ID';


--
-- Name: COLUMN xy_member.username; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.username IS '用户名';


--
-- Name: COLUMN xy_member.password; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.password IS '密码（MD5+salt加密）';
COMMENT ON COLUMN public.xy_member.salt IS '密码盐';


--
-- Name: COLUMN xy_member.mobile; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.mobile IS '手机号';


--
-- Name: COLUMN xy_member.email; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.email IS '邮箱';


--
-- Name: COLUMN xy_member.nickname; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.nickname IS '昵称';


--
-- Name: COLUMN xy_member.avatar; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.avatar IS '头像';


--
-- Name: COLUMN xy_member.gender; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.gender IS '性别：0=未知 1=男 2=女';


--
-- Name: COLUMN xy_member.birthday; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.birthday IS '生日';


--
-- Name: COLUMN xy_member.money; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.money IS '余额';


--
-- Name: COLUMN xy_member.score; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.score IS '积分';


--
-- Name: COLUMN xy_member.level; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.level IS '会员等级';


--
-- Name: COLUMN xy_member.group_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.group_id IS '会员分组ID';


--
-- Name: COLUMN xy_member.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.status IS '状态：0=禁用 1=正常';


--
-- Name: COLUMN xy_member.last_login_ip; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.last_login_ip IS '最后登录IP';


--
-- Name: COLUMN xy_member.last_login_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.last_login_at IS 'last login time';


--
-- Name: COLUMN xy_member.login_count; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.login_count IS '登录次数';


--
-- Name: COLUMN xy_member.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.created_at IS '创建时间';


--
-- Name: COLUMN xy_member.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.updated_at IS '更新时间';


--
-- Name: COLUMN xy_member.deleted_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member.deleted_at IS 'deleted time';


--
-- Name: xy_member_oauth; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_member_oauth (
    id bigint NOT NULL,
    member_id bigint NOT NULL,
    platform character varying(32) NOT NULL,
    openid character varying(128) NOT NULL,
    unionid character varying(128) DEFAULT ''::character varying NOT NULL,
    session_key character varying(128) DEFAULT ''::character varying NOT NULL,
    nickname character varying(100) DEFAULT ''::character varying NOT NULL,
    avatar character varying(500) DEFAULT ''::character varying NOT NULL,
    extra text DEFAULT '' NOT NULL,
    created_at bigint,
    updated_at bigint,
    deleted_at bigint DEFAULT 0 NOT NULL
);

COMMENT ON TABLE public.xy_member_oauth IS 'OAuth table';
COMMENT ON COLUMN public.xy_member_oauth.id IS 'PK';
COMMENT ON COLUMN public.xy_member_oauth.member_id IS 'member FK';
COMMENT ON COLUMN public.xy_member_oauth.platform IS 'platform: wechat_mapp/wechat_oa/qq/alipay';
COMMENT ON COLUMN public.xy_member_oauth.openid IS 'openid';
COMMENT ON COLUMN public.xy_member_oauth.unionid IS 'unionid';
COMMENT ON COLUMN public.xy_member_oauth.session_key IS 'session_key';
COMMENT ON COLUMN public.xy_member_oauth.nickname IS 'nickname';
COMMENT ON COLUMN public.xy_member_oauth.avatar IS 'avatar url';
COMMENT ON COLUMN public.xy_member_oauth.extra IS 'extra json';
COMMENT ON COLUMN public.xy_member_oauth.created_at IS 'created time';
COMMENT ON COLUMN public.xy_member_oauth.updated_at IS 'updated time';
COMMENT ON COLUMN public.xy_member_oauth.deleted_at IS 'deleted time';

CREATE SEQUENCE public.xy_member_oauth_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.xy_member_oauth_id_seq OWNED BY public.xy_member_oauth.id;
ALTER TABLE ONLY public.xy_member_oauth ALTER COLUMN id SET DEFAULT nextval('public.xy_member_oauth_id_seq'::regclass);
ALTER TABLE ONLY public.xy_member_oauth ADD CONSTRAINT xy_member_oauth_pkey PRIMARY KEY (id);
CREATE UNIQUE INDEX idx_member_oauth_platform_openid ON public.xy_member_oauth (platform, openid);
CREATE INDEX idx_member_oauth_member ON public.xy_member_oauth (member_id);

--
-- Name: xy_member_checkin; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_member_checkin (
    id bigint NOT NULL,
    member_id bigint DEFAULT 0 NOT NULL,
    checkin_date bigint,
    score integer DEFAULT 0 NOT NULL,
    continuous_days integer DEFAULT 1 NOT NULL,
    created_at bigint
);


--
-- Name: TABLE xy_member_checkin; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_member_checkin IS '会员签到记录';


--
-- Name: COLUMN xy_member_checkin.member_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_checkin.member_id IS '会员ID';


--
-- Name: COLUMN xy_member_checkin.checkin_date; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_checkin.checkin_date IS '签到日期';


--
-- Name: COLUMN xy_member_checkin.score; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_checkin.score IS '本次获得积分';


--
-- Name: COLUMN xy_member_checkin.continuous_days; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_checkin.continuous_days IS '连续签到天数';


--
-- Name: COLUMN xy_member_checkin.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_checkin.created_at IS '签到时间';


--
-- Name: xy_member_checkin_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_member_checkin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_member_checkin_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_member_checkin_id_seq OWNED BY public.xy_member_checkin.id;


--
-- Name: xy_member_group; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_member_group (
    id bigint NOT NULL,
    name character varying(32) DEFAULT ''::character varying NOT NULL,
    rules text,
    status smallint DEFAULT 1 NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    remark character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at bigint,
    updated_at bigint
);


--
-- Name: TABLE xy_member_group; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_member_group IS '会员分组表';


--
-- Name: COLUMN xy_member_group.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_group.id IS '分组ID';


--
-- Name: COLUMN xy_member_group.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_group.name IS '分组名称';


--
-- Name: COLUMN xy_member_group.rules; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_group.rules IS '权限规则（菜单ID列表，逗号分隔）';


--
-- Name: COLUMN xy_member_group.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_group.status IS '状态：0=禁用 1=正常';


--
-- Name: COLUMN xy_member_group.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_group.sort IS '排序';


--
-- Name: COLUMN xy_member_group.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_group.remark IS '备注';


--
-- Name: COLUMN xy_member_group.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_group.created_at IS '创建时间';


--
-- Name: COLUMN xy_member_group.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_group.updated_at IS '更新时间';


--
-- Name: xy_member_group_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_member_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_member_group_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_member_group_id_seq OWNED BY public.xy_member_group.id;


--
-- Name: xy_member_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_member_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_member_id_seq OWNED BY public.xy_member.id;


--
-- Name: xy_member_login_log; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_member_login_log (
    id bigint NOT NULL,
    member_id bigint DEFAULT 0 NOT NULL,
    username character varying(32) DEFAULT ''::character varying NOT NULL,
    ip character varying(50) DEFAULT ''::character varying NOT NULL,
    user_agent character varying(512) DEFAULT ''::character varying NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    message character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at bigint
);


--
-- Name: TABLE xy_member_login_log; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_member_login_log IS '会员登录日志表';


--
-- Name: COLUMN xy_member_login_log.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_login_log.id IS 'ID';


--
-- Name: COLUMN xy_member_login_log.member_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_login_log.member_id IS '会员ID';


--
-- Name: COLUMN xy_member_login_log.username; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_login_log.username IS '用户名';


--
-- Name: COLUMN xy_member_login_log.ip; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_login_log.ip IS '登录IP';


--
-- Name: COLUMN xy_member_login_log.user_agent; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_login_log.user_agent IS 'User-Agent';


--
-- Name: COLUMN xy_member_login_log.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_login_log.status IS '状态:0=成功,1=失败';


--
-- Name: COLUMN xy_member_login_log.message; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_login_log.message IS '提示信息';


--
-- Name: COLUMN xy_member_login_log.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_login_log.created_at IS '创建时间';


--
-- Name: xy_member_login_log_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_member_login_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_member_login_log_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_member_login_log_id_seq OWNED BY public.xy_member_login_log.id;


--
-- Name: xy_member_menu; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_member_menu (
    id bigint NOT NULL,
    pid bigint DEFAULT 0 NOT NULL,
    title character varying(32) DEFAULT ''::character varying NOT NULL,
    name character varying(64) DEFAULT ''::character varying NOT NULL,
    path character varying(128) DEFAULT ''::character varying NOT NULL,
    component character varying(255) DEFAULT ''::character varying NOT NULL,
    icon character varying(64) DEFAULT ''::character varying NOT NULL,
    menu_type character varying(20) DEFAULT 'tab'::character varying NOT NULL,
    url character varying(500) DEFAULT ''::character varying NOT NULL,
    no_login_valid smallint DEFAULT 0 NOT NULL,
    extend character varying(20) DEFAULT 'none'::character varying NOT NULL,
    remark character varying(255) DEFAULT ''::character varying NOT NULL,
    type character varying(20) DEFAULT 'menu'::character varying NOT NULL,
    nav_show_children smallint DEFAULT 0 NOT NULL,
    permission character varying(64) DEFAULT ''::character varying NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_at bigint,
    updated_at bigint
);


--
-- Name: TABLE xy_member_menu; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_member_menu IS '会员菜单表';


--
-- Name: COLUMN xy_member_menu.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.id IS '菜单ID';


--
-- Name: COLUMN xy_member_menu.pid; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.pid IS '父级ID';


--
-- Name: COLUMN xy_member_menu.title; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.title IS '菜单名称';


--
-- Name: COLUMN xy_member_menu.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.name IS '路由名称';


--
-- Name: COLUMN xy_member_menu.path; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.path IS '路由路径';


--
-- Name: COLUMN xy_member_menu.component; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.component IS 'Vue组件路径（相对于views/frontend/）';


--
-- Name: COLUMN xy_member_menu.icon; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.icon IS '图标';


--
-- Name: COLUMN xy_member_menu.menu_type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.menu_type IS '菜单打开方式：tab=标签页, link=外链, iframe=内嵌';


--
-- Name: COLUMN xy_member_menu.url; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.url IS '外链/iframe地址';


--
-- Name: COLUMN xy_member_menu.no_login_valid; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.no_login_valid IS '未登录是否有效：0=否 1=是（公开路由）';


--
-- Name: COLUMN xy_member_menu.extend; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.extend IS '扩展属性：none=无, add_rules_only=仅添加为路由, add_menu_only=仅添加为菜单';


--
-- Name: COLUMN xy_member_menu.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.remark IS '备注';


--
-- Name: COLUMN xy_member_menu.type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.type IS '类型：route=普通路由, menu_dir=会员中心菜单目录, menu=会员中心菜单项, nav=顶栏菜单项, nav_user_menu=顶栏会员菜单下拉, button=页面按钮';


--
-- Name: COLUMN xy_member_menu.nav_show_children; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.nav_show_children IS '顶栏展示子菜单：0否 1是（仅nav）';


--
-- Name: COLUMN xy_member_menu.permission; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.permission IS '权限标识';


--
-- Name: COLUMN xy_member_menu.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.sort IS '排序';


--
-- Name: COLUMN xy_member_menu.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.status IS '状态：0=禁用 1=正常';


--
-- Name: COLUMN xy_member_menu.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.created_at IS '创建时间';


--
-- Name: COLUMN xy_member_menu.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_menu.updated_at IS '更新时间';


--
-- Name: xy_member_menu_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_member_menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_member_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_member_menu_id_seq OWNED BY public.xy_member_menu.id;


--
-- Name: xy_member_money_log; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_member_money_log (
    id bigint NOT NULL,
    member_id bigint DEFAULT 0 NOT NULL,
    money integer DEFAULT 0 NOT NULL,
    before integer DEFAULT 0 NOT NULL,
    after integer DEFAULT 0 NOT NULL,
    memo character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at bigint
);


--
-- Name: TABLE xy_member_money_log; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_member_money_log IS '会员余额变动日志';


--
-- Name: COLUMN xy_member_money_log.member_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_money_log.member_id IS '会员ID';


--
-- Name: COLUMN xy_member_money_log.money; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_money_log.money IS '变动金额（分，正数=增加，负数=减少）';


--
-- Name: COLUMN xy_member_money_log.before; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_money_log.before IS '变动前余额（分）';


--
-- Name: COLUMN xy_member_money_log.after; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_money_log.after IS '变动后余额（分）';


--
-- Name: COLUMN xy_member_money_log.memo; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_money_log.memo IS '变动说明';


--
-- Name: COLUMN xy_member_money_log.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_money_log.created_at IS '创建时间';


--
-- Name: xy_member_money_log_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_member_money_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_member_money_log_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_member_money_log_id_seq OWNED BY public.xy_member_money_log.id;


--
-- Name: xy_member_notice; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_member_notice (
    id bigint NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    content text,
    type character varying(20) DEFAULT 'system'::character varying NOT NULL,
    target character varying(20) DEFAULT 'all'::character varying NOT NULL,
    target_id bigint DEFAULT 0 NOT NULL,
    sender character varying(50) DEFAULT '系统'::character varying NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_at bigint
);


--
-- Name: TABLE xy_member_notice; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_member_notice IS '会员通知';


--
-- Name: COLUMN xy_member_notice.title; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_notice.title IS '通知标题';


--
-- Name: COLUMN xy_member_notice.content; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_notice.content IS '通知内容';


--
-- Name: COLUMN xy_member_notice.type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_notice.type IS '通知类型:system=系统通知,announce=公告,feature=功能更新,maintain=维护通知';


--
-- Name: COLUMN xy_member_notice.target; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_notice.target IS '目标:all=全部会员,group=指定分组';


--
-- Name: COLUMN xy_member_notice.target_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_notice.target_id IS '目标分组ID（target=group时有效）';


--
-- Name: COLUMN xy_member_notice.sender; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_notice.sender IS '发送者';


--
-- Name: COLUMN xy_member_notice.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_notice.status IS '状态:0=草稿,1=已发布';


--
-- Name: COLUMN xy_member_notice.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_notice.created_at IS '创建时间';


--
-- Name: xy_member_notice_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_member_notice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_member_notice_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_member_notice_id_seq OWNED BY public.xy_member_notice.id;


--
-- Name: xy_member_notice_read; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_member_notice_read (
    id bigint NOT NULL,
    notice_id bigint DEFAULT 0 NOT NULL,
    member_id bigint DEFAULT 0 NOT NULL,
    read_at bigint
);


--
-- Name: TABLE xy_member_notice_read; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_member_notice_read IS '会员通知已读记录';


--
-- Name: COLUMN xy_member_notice_read.notice_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_notice_read.notice_id IS '通知ID';


--
-- Name: COLUMN xy_member_notice_read.member_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_notice_read.member_id IS '会员ID';


--
-- Name: COLUMN xy_member_notice_read.read_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_notice_read.read_at IS '阅读时间';


--
-- Name: xy_member_notice_read_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_member_notice_read_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_member_notice_read_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_member_notice_read_id_seq OWNED BY public.xy_member_notice_read.id;


--
-- Name: xy_member_score_log; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_member_score_log (
    id bigint NOT NULL,
    member_id bigint DEFAULT 0 NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    before integer DEFAULT 0 NOT NULL,
    after integer DEFAULT 0 NOT NULL,
    memo character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at bigint
);


--
-- Name: TABLE xy_member_score_log; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_member_score_log IS '会员积分变动日志';


--
-- Name: COLUMN xy_member_score_log.member_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_score_log.member_id IS '会员ID';


--
-- Name: COLUMN xy_member_score_log.score; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_score_log.score IS '变动积分（正数=增加，负数=减少）';


--
-- Name: COLUMN xy_member_score_log.before; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_score_log.before IS '变动前积分';


--
-- Name: COLUMN xy_member_score_log.after; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_score_log.after IS '变动后积分';


--
-- Name: COLUMN xy_member_score_log.memo; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_score_log.memo IS '变动说明';


--
-- Name: COLUMN xy_member_score_log.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_member_score_log.created_at IS '创建时间';


--
-- Name: xy_member_score_log_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_member_score_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_member_score_log_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_member_score_log_id_seq OWNED BY public.xy_member_score_log.id;


--
-- Name: xy_sys_attachment; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_sys_attachment (
    id bigint NOT NULL,
    topic character varying(20) DEFAULT ''::character varying NOT NULL,
    user_id bigint DEFAULT 0 NOT NULL,
    url character varying(255) DEFAULT ''::character varying NOT NULL,
    width integer DEFAULT 0 NOT NULL,
    height integer DEFAULT 0 NOT NULL,
    name character varying(120) DEFAULT ''::character varying NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    mimetype character varying(100) DEFAULT ''::character varying NOT NULL,
    quote integer DEFAULT 0 NOT NULL,
    storage character varying(50) DEFAULT 'local'::character varying NOT NULL,
    sha1 character varying(40) DEFAULT ''::character varying NOT NULL,
    create_time bigint NOT NULL,
    update_time bigint NOT NULL
);


--
-- Name: TABLE xy_sys_attachment; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_sys_attachment IS '附件表';


--
-- Name: COLUMN xy_sys_attachment.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.id IS 'ID';


--
-- Name: COLUMN xy_sys_attachment.topic; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.topic IS '分组/主题标识';


--
-- Name: COLUMN xy_sys_attachment.user_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.user_id IS '上传用户ID（预留）';


--
-- Name: COLUMN xy_sys_attachment.url; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.url IS '物理路径（相对路径）';


--
-- Name: COLUMN xy_sys_attachment.width; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.width IS '宽度';


--
-- Name: COLUMN xy_sys_attachment.height; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.height IS '高度';


--
-- Name: COLUMN xy_sys_attachment.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.name IS '原始名称';


--
-- Name: COLUMN xy_sys_attachment.size; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.size IS '大小（字节）';


--
-- Name: COLUMN xy_sys_attachment.mimetype; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.mimetype IS 'MIME类型';


--
-- Name: COLUMN xy_sys_attachment.quote; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.quote IS '上传(引用)次数';


--
-- Name: COLUMN xy_sys_attachment.storage; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.storage IS '存储方式：local=本地';


--
-- Name: COLUMN xy_sys_attachment.sha1; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.sha1 IS 'sha1摘要';


--
-- Name: COLUMN xy_sys_attachment.create_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.create_time IS '创建时间';


--
-- Name: COLUMN xy_sys_attachment.update_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_attachment.update_time IS '更新时间';


--
-- Name: xy_sys_attachment_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_sys_attachment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_sys_attachment_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_sys_attachment_id_seq OWNED BY public.xy_sys_attachment.id;


--
-- Name: xy_sys_config; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_sys_config (
    id bigint NOT NULL,
    "group" character varying(64) DEFAULT ''::character varying NOT NULL,
    group_name character varying(64) DEFAULT ''::character varying NOT NULL,
    name character varying(128) DEFAULT ''::character varying NOT NULL,
    key character varying(128) DEFAULT ''::character varying NOT NULL,
    value text,
    type character varying(32) DEFAULT 'text'::character varying NOT NULL,
    options jsonb,
    rules jsonb,
    sort integer DEFAULT 0 NOT NULL,
    remark character varying(255) DEFAULT ''::character varying NOT NULL,
    allow_del smallint DEFAULT 0 NOT NULL,
    created_by bigint,
    updated_by bigint,
    create_time bigint NOT NULL,
    update_time bigint NOT NULL
);


--
-- Name: TABLE xy_sys_config; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_sys_config IS '系统配置（定义+当前值）';


--
-- Name: COLUMN xy_sys_config.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.id IS '主键';


--
-- Name: COLUMN xy_sys_config."group"; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config."group" IS '分组标识，如 basics/mail/oss';


--
-- Name: COLUMN xy_sys_config.group_name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.group_name IS '分组名称';


--
-- Name: COLUMN xy_sys_config.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.name IS '配置项显示名';


--
-- Name: COLUMN xy_sys_config.key; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.key IS '配置键（唯一）';


--
-- Name: COLUMN xy_sys_config.value; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.value IS '配置值（字符串/JSON）';


--
-- Name: COLUMN xy_sys_config.type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.type IS '控件类型:text/textarea/number/switch/select/radio/checkbox/json/object/array/color/upload';


--
-- Name: COLUMN xy_sys_config.options; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.options IS '组件参数/选项 JSON';


--
-- Name: COLUMN xy_sys_config.rules; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.rules IS '校验规则 JSON';


--
-- Name: COLUMN xy_sys_config.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.sort IS '排序(大靠后)';


--
-- Name: COLUMN xy_sys_config.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.remark IS '备注';


--
-- Name: COLUMN xy_sys_config.allow_del; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.allow_del IS '允许删除:0=否,1=是';


--
-- Name: COLUMN xy_sys_config.created_by; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.created_by IS '创建人';


--
-- Name: COLUMN xy_sys_config.updated_by; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.updated_by IS '更新人';


--
-- Name: COLUMN xy_sys_config.create_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.create_time IS '创建时间';


--
-- Name: COLUMN xy_sys_config.update_time; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_config.update_time IS '更新时间';


--
-- Name: xy_sys_config_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_sys_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_sys_config_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_sys_config_id_seq OWNED BY public.xy_sys_config.id;


--
-- Name: xy_sys_cron; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_sys_cron (
    id bigint NOT NULL,
    group_id bigint DEFAULT 0 NOT NULL,
    title character varying(200) DEFAULT ''::character varying NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    params character varying(1000) DEFAULT ''::character varying NOT NULL,
    pattern character varying(100) DEFAULT ''::character varying NOT NULL,
    policy smallint DEFAULT 1 NOT NULL,
    count integer DEFAULT 0 NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    remark character varying(500) DEFAULT ''::character varying NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_at bigint DEFAULT 0 NOT NULL,
    updated_at bigint DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_sys_cron; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_sys_cron IS '定时任务表';


--
-- Name: COLUMN xy_sys_cron.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.id IS '任务ID';


--
-- Name: COLUMN xy_sys_cron.group_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.group_id IS '分组ID';


--
-- Name: COLUMN xy_sys_cron.title; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.title IS '任务标题';


--
-- Name: COLUMN xy_sys_cron.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.name IS '任务标识（唯一，对应代码注册名）';


--
-- Name: COLUMN xy_sys_cron.params; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.params IS '任务参数（逗号分隔）';


--
-- Name: COLUMN xy_sys_cron.pattern; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.pattern IS 'Cron表达式';


--
-- Name: COLUMN xy_sys_cron.policy; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.policy IS '策略:1并行,2单例,3单次,4固定次数';


--
-- Name: COLUMN xy_sys_cron.count; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.count IS '固定次数（policy=4时有效）';


--
-- Name: COLUMN xy_sys_cron.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.sort IS '排序';


--
-- Name: COLUMN xy_sys_cron.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.remark IS '备注';


--
-- Name: COLUMN xy_sys_cron.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.status IS '状态:0禁用,1启用';


--
-- Name: COLUMN xy_sys_cron.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.created_at IS '创建时间';


--
-- Name: COLUMN xy_sys_cron.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron.updated_at IS '更新时间';


--
-- Name: xy_sys_cron_group; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_sys_cron_group (
    id bigint NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    remark character varying(500) DEFAULT ''::character varying NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    created_at bigint DEFAULT 0 NOT NULL,
    updated_at bigint DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_sys_cron_group; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_sys_cron_group IS '定时任务分组表';


--
-- Name: COLUMN xy_sys_cron_group.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_group.id IS '分组ID';


--
-- Name: COLUMN xy_sys_cron_group.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_group.name IS '分组名称';


--
-- Name: COLUMN xy_sys_cron_group.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_group.sort IS '排序（越小越靠前）';


--
-- Name: COLUMN xy_sys_cron_group.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_group.remark IS '备注';


--
-- Name: COLUMN xy_sys_cron_group.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_group.status IS '状态:0禁用,1启用';


--
-- Name: COLUMN xy_sys_cron_group.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_group.created_at IS '创建时间';


--
-- Name: COLUMN xy_sys_cron_group.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_group.updated_at IS '更新时间';


--
-- Name: xy_sys_cron_group_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_sys_cron_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_sys_cron_group_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_sys_cron_group_id_seq OWNED BY public.xy_sys_cron_group.id;


--
-- Name: xy_sys_cron_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_sys_cron_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_sys_cron_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_sys_cron_id_seq OWNED BY public.xy_sys_cron.id;


--
-- Name: xy_sys_cron_log; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_sys_cron_log (
    id bigint NOT NULL,
    cron_id bigint DEFAULT 0 NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    title character varying(200) DEFAULT ''::character varying NOT NULL,
    params character varying(1000) DEFAULT ''::character varying NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    output text,
    err_msg text,
    take_ms integer DEFAULT 0 NOT NULL,
    created_at bigint DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_sys_cron_log; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_sys_cron_log IS '定时任务执行日志表';


--
-- Name: COLUMN xy_sys_cron_log.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_log.id IS '日志ID';


--
-- Name: COLUMN xy_sys_cron_log.cron_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_log.cron_id IS '任务ID';


--
-- Name: COLUMN xy_sys_cron_log.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_log.name IS '任务标识';


--
-- Name: COLUMN xy_sys_cron_log.title; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_log.title IS '任务标题';


--
-- Name: COLUMN xy_sys_cron_log.params; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_log.params IS '执行参数';


--
-- Name: COLUMN xy_sys_cron_log.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_log.status IS '状态:1成功,2失败';


--
-- Name: COLUMN xy_sys_cron_log.output; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_log.output IS '执行输出';


--
-- Name: COLUMN xy_sys_cron_log.err_msg; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_log.err_msg IS '错误信息';


--
-- Name: COLUMN xy_sys_cron_log.take_ms; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_log.take_ms IS '耗时(毫秒)';


--
-- Name: COLUMN xy_sys_cron_log.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_cron_log.created_at IS '执行时间';


--
-- Name: xy_sys_cron_log_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_sys_cron_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_sys_cron_log_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_sys_cron_log_id_seq OWNED BY public.xy_sys_cron_log.id;


--
-- Name: xy_sys_gen_codes; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_sys_gen_codes (
    id bigint NOT NULL,
    gen_type smallint DEFAULT 10 NOT NULL,
    db_name character varying(50) DEFAULT ''::character varying NOT NULL,
    table_name character varying(100) DEFAULT ''::character varying NOT NULL,
    table_comment character varying(200) DEFAULT ''::character varying NOT NULL,
    var_name character varying(100) DEFAULT ''::character varying NOT NULL,
    options jsonb,
    status smallint DEFAULT 2 NOT NULL,
    created_at bigint DEFAULT 0 NOT NULL,
    updated_at bigint DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_sys_gen_codes; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_sys_gen_codes IS '代码生成配置主表';


--
-- Name: COLUMN xy_sys_gen_codes.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes.id IS '主键';


--
-- Name: COLUMN xy_sys_gen_codes.gen_type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes.gen_type IS '生成类型:10=普通列表,11=树表';


--
-- Name: COLUMN xy_sys_gen_codes.db_name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes.db_name IS '数据库名';


--
-- Name: COLUMN xy_sys_gen_codes.table_name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes.table_name IS '数据表名';


--
-- Name: COLUMN xy_sys_gen_codes.table_comment; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes.table_comment IS '表注释(菜单名)';


--
-- Name: COLUMN xy_sys_gen_codes.var_name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes.var_name IS '实体名(PascalCase)';


--
-- Name: COLUMN xy_sys_gen_codes.options; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes.options IS '生成选项(JSON)';


--
-- Name: COLUMN xy_sys_gen_codes.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes.status IS '状态:1=已生成,2=未生成';


--
-- Name: COLUMN xy_sys_gen_codes.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes.created_at IS '创建时间戳';


--
-- Name: COLUMN xy_sys_gen_codes.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes.updated_at IS '更新时间戳';


--
-- Name: xy_sys_gen_codes_column; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_sys_gen_codes_column (
    id bigint NOT NULL,
    gen_id bigint DEFAULT 0 NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    go_name character varying(100) DEFAULT ''::character varying NOT NULL,
    ts_name character varying(100) DEFAULT ''::character varying NOT NULL,
    db_type character varying(50) DEFAULT ''::character varying NOT NULL,
    go_type character varying(50) DEFAULT ''::character varying NOT NULL,
    ts_type character varying(50) DEFAULT ''::character varying NOT NULL,
    comment character varying(200) DEFAULT ''::character varying NOT NULL,
    is_pk smallint DEFAULT 0 NOT NULL,
    is_required smallint DEFAULT 0 NOT NULL,
    is_list smallint DEFAULT 1 NOT NULL,
    is_edit smallint DEFAULT 1 NOT NULL,
    is_query smallint DEFAULT 0 NOT NULL,
    query_type character varying(20) DEFAULT 'eq'::character varying NOT NULL,
    design_type character varying(30) NOT NULL,
    extra text,
    form_type character varying(30) DEFAULT 'input'::character varying NOT NULL,
    dict_type character varying(50) DEFAULT ''::character varying NOT NULL,
    sort integer DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_sys_gen_codes_column; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_sys_gen_codes_column IS '代码生成字段配置表';


--
-- Name: COLUMN xy_sys_gen_codes_column.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.id IS '主键';


--
-- Name: COLUMN xy_sys_gen_codes_column.gen_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.gen_id IS '关联gen_codes.id';


--
-- Name: COLUMN xy_sys_gen_codes_column.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.name IS '数据库字段名';


--
-- Name: COLUMN xy_sys_gen_codes_column.go_name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.go_name IS 'Go字段名';


--
-- Name: COLUMN xy_sys_gen_codes_column.ts_name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.ts_name IS 'TS字段名';


--
-- Name: COLUMN xy_sys_gen_codes_column.db_type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.db_type IS '数据库类型';


--
-- Name: COLUMN xy_sys_gen_codes_column.go_type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.go_type IS 'Go类型';


--
-- Name: COLUMN xy_sys_gen_codes_column.ts_type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.ts_type IS 'TS类型';


--
-- Name: COLUMN xy_sys_gen_codes_column.comment; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.comment IS '字段注释';


--
-- Name: COLUMN xy_sys_gen_codes_column.is_pk; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.is_pk IS '是否主键:0=否,1=是';


--
-- Name: COLUMN xy_sys_gen_codes_column.is_required; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.is_required IS '是否必填:0=否,1=是';


--
-- Name: COLUMN xy_sys_gen_codes_column.is_list; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.is_list IS '表格列显示:0=否,1=是';


--
-- Name: COLUMN xy_sys_gen_codes_column.is_edit; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.is_edit IS '表单编辑显示:0=否,1=是';


--
-- Name: COLUMN xy_sys_gen_codes_column.is_query; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.is_query IS '搜索条件:0=否,1=是';


--
-- Name: COLUMN xy_sys_gen_codes_column.query_type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.query_type IS '查询方式:eq/like/between/gt/in';


--
-- Name: COLUMN xy_sys_gen_codes_column.design_type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.design_type IS '设计类型(designType)';


--
-- Name: COLUMN xy_sys_gen_codes_column.extra; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.extra IS '扩展配置JSON(关联表配置/表格属性/表单属性等)';


--
-- Name: COLUMN xy_sys_gen_codes_column.form_type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.form_type IS '表单组件类型';


--
-- Name: COLUMN xy_sys_gen_codes_column.dict_type; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.dict_type IS '关联字典';


--
-- Name: COLUMN xy_sys_gen_codes_column.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_sys_gen_codes_column.sort IS '排序';


--
-- Name: xy_sys_gen_codes_column_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_sys_gen_codes_column_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_sys_gen_codes_column_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_sys_gen_codes_column_id_seq OWNED BY public.xy_sys_gen_codes_column.id;


--
-- Name: xy_sys_gen_codes_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_sys_gen_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_sys_gen_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_sys_gen_codes_id_seq OWNED BY public.xy_sys_gen_codes.id;


--
-- Name: xy_test_category; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_test_category (
    id bigint NOT NULL,
    parent_id bigint DEFAULT 0 NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    icon character varying(255) DEFAULT ''::character varying NOT NULL,
    image character varying(500) DEFAULT ''::character varying NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    remark character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at bigint,
    updated_at bigint
);


--
-- Name: TABLE xy_test_category; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_test_category IS '测试分类表';


--
-- Name: COLUMN xy_test_category.parent_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_category.parent_id IS '鐖剁骇ID';


--
-- Name: COLUMN xy_test_category.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_category.name IS '分类名称';


--
-- Name: COLUMN xy_test_category.icon; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_category.icon IS '图标';


--
-- Name: COLUMN xy_test_category.image; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_category.image IS '分类图片';


--
-- Name: COLUMN xy_test_category.sort; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_category.sort IS '排序';


--
-- Name: COLUMN xy_test_category.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_category.status IS '状态:0=禁用,1=启用';


--
-- Name: COLUMN xy_test_category.remark; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_category.remark IS '备注';


--
-- Name: COLUMN xy_test_category.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_category.created_at IS '创建时间';


--
-- Name: COLUMN xy_test_category.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_category.updated_at IS '更新时间';


--
-- Name: xy_test_category_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_test_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_test_category_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_test_category_id_seq OWNED BY public.xy_test_category.id;


--
-- Name: xy_test_code; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_test_code (
    id bigint NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    member_id integer DEFAULT 0 NOT NULL
);


--
-- Name: TABLE xy_test_code; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_test_code IS '测试生成';


--
-- Name: COLUMN xy_test_code.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_code.id IS '主键';


--
-- Name: COLUMN xy_test_code.name; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_code.name IS '名称';


--
-- Name: COLUMN xy_test_code.member_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_code.member_id IS '关联ID';


--
-- Name: xy_test_code_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_test_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_test_code_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_test_code_id_seq OWNED BY public.xy_test_code.id;


--
-- Name: xy_test_codec; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_test_codec (
    id bigint NOT NULL,
    status smallint DEFAULT 0 NOT NULL,
    create_time time without time zone
);


--
-- Name: TABLE xy_test_codec; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_test_codec IS '测试手动创建';


--
-- Name: COLUMN xy_test_codec.id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_codec.id IS '主键';


--
-- Name: COLUMN xy_test_codec.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_codec.status IS '状态:0=关闭,1=开启';


--
-- Name: xy_test_codec_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_test_codec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_test_codec_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_test_codec_id_seq OWNED BY public.xy_test_codec.id;


--
-- Name: xy_test_order; Type: TABLE; Schema: xygonew; Owner: -
--

CREATE TABLE public.xy_test_order (
    id bigint NOT NULL,
    member_id bigint DEFAULT 0 NOT NULL,
    apply_id bigint DEFAULT 0 NOT NULL,
    amount numeric(10,2) DEFAULT 0.00 NOT NULL,
    status smallint DEFAULT 0 NOT NULL,
    memo character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at bigint,
    updated_at bigint
);


--
-- Name: TABLE xy_test_order; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON TABLE public.xy_test_order IS '测试订单表';


--
-- Name: COLUMN xy_test_order.member_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_order.member_id IS '卖家ID';


--
-- Name: COLUMN xy_test_order.apply_id; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_order.apply_id IS '买家ID';


--
-- Name: COLUMN xy_test_order.amount; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_order.amount IS '订单金额';


--
-- Name: COLUMN xy_test_order.status; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_order.status IS '状态:0=待处理,1=已完成,2=已取消';


--
-- Name: COLUMN xy_test_order.memo; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_order.memo IS '备注';


--
-- Name: COLUMN xy_test_order.created_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_order.created_at IS '创建时间';


--
-- Name: COLUMN xy_test_order.updated_at; Type: COMMENT; Schema: xygonew; Owner: -
--

COMMENT ON COLUMN public.xy_test_order.updated_at IS '更新时间';


--
-- Name: xy_test_order_id_seq; Type: SEQUENCE; Schema: xygonew; Owner: -
--

CREATE SEQUENCE public.xy_test_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xy_test_order_id_seq; Type: SEQUENCE OWNED BY; Schema: xygonew; Owner: -
--

ALTER SEQUENCE public.xy_test_order_id_seq OWNED BY public.xy_test_order.id;


--
-- Name: xy_admin_chat_message id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_chat_message ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_chat_message_id_seq'::regclass);


--
-- Name: xy_admin_chat_session id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_chat_session ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_chat_session_id_seq'::regclass);


--
-- Name: xy_admin_chat_session_member id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_chat_session_member ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_chat_session_member_id_seq'::regclass);


--
-- Name: xy_admin_dept id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_dept ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_dept_id_seq'::regclass);


--
-- Name: xy_admin_dept_closure id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_dept_closure ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_dept_closure_id_seq'::regclass);


--
-- Name: xy_admin_field_perm id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_field_perm ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_field_perm_id_seq'::regclass);


--
-- Name: xy_admin_login_log id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_login_log ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_login_log_id_seq'::regclass);


--
-- Name: xy_admin_menu id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_menu ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_menu_id_seq'::regclass);


--
-- Name: xy_admin_notice id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_notice ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_notice_id_seq'::regclass);


--
-- Name: xy_admin_notice_read id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_notice_read ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_notice_read_id_seq'::regclass);


--
-- Name: xy_admin_operation_log id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_operation_log ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_operation_log_id_seq'::regclass);


--
-- Name: xy_admin_post id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_post ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_post_id_seq'::regclass);


--
-- Name: xy_admin_role id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_role ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_role_id_seq'::regclass);


--
-- Name: xy_admin_user id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_user ALTER COLUMN id SET DEFAULT nextval('public.xy_admin_user_id_seq'::regclass);


--
-- Name: xy_captcha id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_captcha ALTER COLUMN id SET DEFAULT nextval('public.xy_captcha_id_seq'::regclass);


--
-- Name: xy_demo_article id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_demo_article ALTER COLUMN id SET DEFAULT nextval('public.xy_demo_article_id_seq'::regclass);


--
-- Name: xy_demo_category id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_demo_category ALTER COLUMN id SET DEFAULT nextval('public.xy_demo_category_id_seq'::regclass);


--
-- Name: xy_member id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member ALTER COLUMN id SET DEFAULT nextval('public.xy_member_id_seq'::regclass);


--
-- Name: xy_member_checkin id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_checkin ALTER COLUMN id SET DEFAULT nextval('public.xy_member_checkin_id_seq'::regclass);


--
-- Name: xy_member_group id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_group ALTER COLUMN id SET DEFAULT nextval('public.xy_member_group_id_seq'::regclass);


--
-- Name: xy_member_login_log id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_login_log ALTER COLUMN id SET DEFAULT nextval('public.xy_member_login_log_id_seq'::regclass);


--
-- Name: xy_member_menu id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_menu ALTER COLUMN id SET DEFAULT nextval('public.xy_member_menu_id_seq'::regclass);


--
-- Name: xy_member_money_log id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_money_log ALTER COLUMN id SET DEFAULT nextval('public.xy_member_money_log_id_seq'::regclass);


--
-- Name: xy_member_notice id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_notice ALTER COLUMN id SET DEFAULT nextval('public.xy_member_notice_id_seq'::regclass);


--
-- Name: xy_member_notice_read id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_notice_read ALTER COLUMN id SET DEFAULT nextval('public.xy_member_notice_read_id_seq'::regclass);


--
-- Name: xy_member_score_log id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_score_log ALTER COLUMN id SET DEFAULT nextval('public.xy_member_score_log_id_seq'::regclass);


--
-- Name: xy_sys_attachment id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_attachment ALTER COLUMN id SET DEFAULT nextval('public.xy_sys_attachment_id_seq'::regclass);


--
-- Name: xy_sys_config id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_config ALTER COLUMN id SET DEFAULT nextval('public.xy_sys_config_id_seq'::regclass);


--
-- Name: xy_sys_cron id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_cron ALTER COLUMN id SET DEFAULT nextval('public.xy_sys_cron_id_seq'::regclass);


--
-- Name: xy_sys_cron_group id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_cron_group ALTER COLUMN id SET DEFAULT nextval('public.xy_sys_cron_group_id_seq'::regclass);


--
-- Name: xy_sys_cron_log id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_cron_log ALTER COLUMN id SET DEFAULT nextval('public.xy_sys_cron_log_id_seq'::regclass);


--
-- Name: xy_sys_gen_codes id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_gen_codes ALTER COLUMN id SET DEFAULT nextval('public.xy_sys_gen_codes_id_seq'::regclass);


--
-- Name: xy_sys_gen_codes_column id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_gen_codes_column ALTER COLUMN id SET DEFAULT nextval('public.xy_sys_gen_codes_column_id_seq'::regclass);


--
-- Name: xy_test_category id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_test_category ALTER COLUMN id SET DEFAULT nextval('public.xy_test_category_id_seq'::regclass);


--
-- Name: xy_test_code id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_test_code ALTER COLUMN id SET DEFAULT nextval('public.xy_test_code_id_seq'::regclass);


--
-- Name: xy_test_codec id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_test_codec ALTER COLUMN id SET DEFAULT nextval('public.xy_test_codec_id_seq'::regclass);


--
-- Name: xy_test_order id; Type: DEFAULT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_test_order ALTER COLUMN id SET DEFAULT nextval('public.xy_test_order_id_seq'::regclass);


--
-- Data for Name: xy_admin_chat_message; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (1, 1, 2, 1, '你好', 1770709004);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (2, 1, 2, 1, '我是李小龙', 1770709123);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (3, 1, 2, 1, '你试试', 1770709436);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (4, 1, 2, 1, '自己当时发完自己看不到 的重新打卡才能看到', 1770709475);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (5, 1, 2, 1, '怎么是', 1770709490);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (6, 1, 2, 1, '你是谁啊', 1770709696);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (7, 1, 2, 1, '我是校长', 1770709712);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (8, 1, 2, 1, '你可以看到我们', 1770709778);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (9, 1, 2, 1, '你是谁', 1770710049);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (10, 1, 2, 1, '我是我', 1770710211);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (11, 1, 2, 1, '我也可能是你', 1770710222);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (12, 1, 2, 1, '你不是我', 1770710429);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (13, 1, 2, 1, '你说话啊', 1770710619);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (14, 1, 2, 1, '我来了', 1770710634);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (15, 1, 1, 1, 'haode', 1770710640);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (16, 1, 1, 2, '/attachment/upload/20260210/b17249d2-0d9d-496d-a6a5-1c9c2c603459.webp', 1770710651);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (17, 4, 0, 3, 'admin2 创建了群聊', 1770711683);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (18, 4, 2, 1, 'hellow', 1770711690);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (19, 4, 1, 1, 'laile', 1770711703);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (20, 1, 1, 1, '我呢', 1770738262);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (21, 1, 1, 1, '这是我', 1770738530);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (22, 1, 1, 1, '你是谁', 1770796950);
INSERT INTO public.xy_admin_chat_message (id, session_id, sender_id, type, content, created_at) VALUES (23, 1, 2, 1, '我是你的人', 1770796994);


--
-- Data for Name: xy_admin_chat_session; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_chat_session (id, type, name, avatar, creator_id, last_message, last_message_time, member_count, created_at, updated_at) VALUES (1, 1, '', '', 2, '我是你的人', 1770796994, 2, 1770708990, 1770796994);
INSERT INTO public.xy_admin_chat_session (id, type, name, avatar, creator_id, last_message, last_message_time, member_count, created_at, updated_at) VALUES (2, 1, '', '', 2, '', 1770711417, 2, 1770711417, 1770711417);
INSERT INTO public.xy_admin_chat_session (id, type, name, avatar, creator_id, last_message, last_message_time, member_count, created_at, updated_at) VALUES (3, 1, '', '', 2, '', 1770711657, 2, 1770711657, 1770711657);
INSERT INTO public.xy_admin_chat_session (id, type, name, avatar, creator_id, last_message, last_message_time, member_count, created_at, updated_at) VALUES (4, 2, 'testgroup', '', 2, 'laile', 1770711703, 4, 1770711683, 1770711703);


--
-- Data for Name: xy_admin_chat_session_member; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_chat_session_member (id, session_id, user_id, role, unread_count, last_read_msg_id, is_muted, is_deleted, joined_at) VALUES (1, 1, 1, 1, 0, 23, 0, 0, 1770708990);
INSERT INTO public.xy_admin_chat_session_member (id, session_id, user_id, role, unread_count, last_read_msg_id, is_muted, is_deleted, joined_at) VALUES (2, 1, 2, 1, 0, 22, 0, 0, 1770708990);
INSERT INTO public.xy_admin_chat_session_member (id, session_id, user_id, role, unread_count, last_read_msg_id, is_muted, is_deleted, joined_at) VALUES (3, 2, 3, 1, 0, 0, 0, 0, 1770711417);
INSERT INTO public.xy_admin_chat_session_member (id, session_id, user_id, role, unread_count, last_read_msg_id, is_muted, is_deleted, joined_at) VALUES (4, 2, 2, 1, 0, 0, 0, 0, 1770711417);
INSERT INTO public.xy_admin_chat_session_member (id, session_id, user_id, role, unread_count, last_read_msg_id, is_muted, is_deleted, joined_at) VALUES (5, 3, 4, 1, 0, 0, 0, 0, 1770711657);
INSERT INTO public.xy_admin_chat_session_member (id, session_id, user_id, role, unread_count, last_read_msg_id, is_muted, is_deleted, joined_at) VALUES (6, 3, 2, 1, 0, 0, 0, 0, 1770711657);
INSERT INTO public.xy_admin_chat_session_member (id, session_id, user_id, role, unread_count, last_read_msg_id, is_muted, is_deleted, joined_at) VALUES (7, 4, 1, 1, 0, 19, 0, 0, 1770711683);
INSERT INTO public.xy_admin_chat_session_member (id, session_id, user_id, role, unread_count, last_read_msg_id, is_muted, is_deleted, joined_at) VALUES (8, 4, 3, 1, 2, 0, 0, 0, 1770711683);
INSERT INTO public.xy_admin_chat_session_member (id, session_id, user_id, role, unread_count, last_read_msg_id, is_muted, is_deleted, joined_at) VALUES (9, 4, 4, 1, 2, 0, 0, 0, 1770711683);
INSERT INTO public.xy_admin_chat_session_member (id, session_id, user_id, role, unread_count, last_read_msg_id, is_muted, is_deleted, joined_at) VALUES (10, 4, 2, 3, 0, 19, 0, 0, 1770711683);


--
-- Data for Name: xy_admin_dept; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_dept (id, parent_id, name, sort, status, remark, create_by, create_time, update_time) VALUES (1, 0, '总公司', 1, 1, '顶级部门', 0, 1768570149, 1768570149);
INSERT INTO public.xy_admin_dept (id, parent_id, name, sort, status, remark, create_by, create_time, update_time) VALUES (2, 1, '技术部', 1, 1, '负责技术开发', 0, 1768570149, 1768570149);
INSERT INTO public.xy_admin_dept (id, parent_id, name, sort, status, remark, create_by, create_time, update_time) VALUES (3, 1, '市场部', 2, 1, '负责市场推广', 0, 1768570149, 1768570149);
INSERT INTO public.xy_admin_dept (id, parent_id, name, sort, status, remark, create_by, create_time, update_time) VALUES (4, 1, '财务部', 3, 1, '负责财务管理', 0, 1768570149, 1768570149);
INSERT INTO public.xy_admin_dept (id, parent_id, name, sort, status, remark, create_by, create_time, update_time) VALUES (5, 2, '前端组', 1, 1, '前端开发团队', 0, 1768570149, 1768570149);
INSERT INTO public.xy_admin_dept (id, parent_id, name, sort, status, remark, create_by, create_time, update_time) VALUES (6, 2, '后端组', 2, 1, '后端开发团队', 0, 1768570149, 1768570149);
INSERT INTO public.xy_admin_dept (id, parent_id, name, sort, status, remark, create_by, create_time, update_time) VALUES (7, 3, '线上推广组', 1, 1, '负责线上营销', 0, 1768570149, 1768570149);
INSERT INTO public.xy_admin_dept (id, parent_id, name, sort, status, remark, create_by, create_time, update_time) VALUES (8, 3, '线下推广组', 2, 1, '负责线下活动', 0, 1768570149, 1768570149);


--
-- Data for Name: xy_admin_dept_closure; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (1, 1, 1, 0);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (2, 1, 2, 1);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (3, 2, 2, 0);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (4, 1, 3, 1);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (5, 3, 3, 0);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (6, 1, 4, 1);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (7, 4, 4, 0);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (8, 1, 5, 2);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (9, 2, 5, 1);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (10, 5, 5, 0);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (11, 1, 6, 2);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (12, 2, 6, 1);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (13, 6, 6, 0);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (14, 1, 7, 2);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (15, 3, 7, 1);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (16, 7, 7, 0);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (17, 1, 8, 2);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (18, 3, 8, 1);
INSERT INTO public.xy_admin_dept_closure (id, ancestor, descendant, level) VALUES (19, 8, 8, 0);


--
-- Data for Name: xy_admin_field_perm; Type: TABLE DATA; Schema: xygonew; Owner: -
--



--
-- Data for Name: xy_admin_login_log; Type: TABLE DATA; Schema: xygonew; Owner: -
--



--
-- Data for Name: xy_admin_menu; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (1, 0, 1, '仪表盘', 'Dashboard', '/dashboard', '/index/index', '', 'ri:pie-chart-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 10, 1, '仪表盘根', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (2, 1, 2, '工作台', 'Console', 'console', '/dashboard/console', '', 'ri:home-smile-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 11, 1, '仪表盘-工作台', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (3, 1, 2, '分析页', 'Analysis', 'analysis', '/dashboard/analysis', '', 'ri:align-item-bottom-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 12, 1, '仪表盘-分析', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (4, 1, 2, '电商页', 'Ecommerce', 'ecommerce', '/dashboard/ecommerce', '', 'ri:bar-chart-box-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 13, 1, '仪表盘-电商', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (10, 0, 1, '模板中心', 'Template', '/template', '/index/index', '', 'ri:apps-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 20, 1, '模板根', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (11, 10, 2, '卡片', 'Cards', 'cards', '/template/cards', '', 'ri:wallet-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 21, 1, '模板-卡片', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (12, 10, 2, '横幅', 'Banners', 'banners', '/template/banners', '', 'ri:rectangle-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 22, 1, '模板-横幅', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (13, 10, 2, '图表', 'Charts', 'charts', '/template/charts', '', 'ri:bar-chart-box-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 23, 1, '模板-图表', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (14, 10, 2, '地图', 'Map', 'map', '/template/map', '', 'ri:map-pin-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 24, 1, '模板-地图', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (15, 10, 2, '聊天', 'Chat', 'chat', '/template/chat', '', 'ri:message-3-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 25, 1, '模板-聊天', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (16, 10, 2, '日历', 'Calendar', 'calendar', '/template/calendar', '', 'ri:calendar-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 26, 1, '模板-日历', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (17, 10, 2, '定价', 'Pricing', 'pricing', '/template/pricing', '', 'ri:money-cny-box-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 27, 1, '模板-定价', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (20, 0, 2, '组件中心', 'Widgets', '/widgets', '/index/index', '', 'ri:apps-2-add-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 30, 1, '', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (21, 20, 2, '图标', 'Icon', 'icon', '/widgets/icon', '', 'ri:palette-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 31, 1, '组件-图标', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (22, 20, 2, '图片裁剪', 'ImageCrop', 'image-crop', '/widgets/image-crop', '', 'ri:screenshot-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 32, 1, '组件-裁剪', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (23, 20, 2, 'Excel', 'Excel', 'excel', '/widgets/excel', '', 'ri:download-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 33, 1, '组件-Excel', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (24, 20, 2, '视频', 'Video', 'video', '/widgets/video', '', 'ri:vidicon-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 34, 1, '组件-视频', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (25, 20, 2, 'CountTo', 'CountTo', 'count-to', '/widgets/count-to', '', 'ri:anthropic-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 35, 1, '组件-CountTo', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (26, 20, 2, '富文本', 'WangEditor', 'wang-editor', '/widgets/wang-editor', '', 'ri:t-box-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 36, 1, '组件-富文本', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (27, 20, 2, '水印', 'Watermark', 'watermark', '/widgets/watermark', '', 'ri:water-flash-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 37, 1, '组件-水印', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (28, 20, 2, '右键菜单', 'ContextMenu', 'context-menu', '/widgets/context-menu', '', 'ri:menu-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 38, 1, '组件-右键', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (29, 20, 2, '二维码', 'Qrcode', 'qrcode', '/widgets/qrcode', '', 'ri:qr-code-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 39, 1, '组件-二维码', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (30, 20, 2, '拖拽', 'Drag', 'drag', '/widgets/drag', '', 'ri:drag-move-fill', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 40, 1, '组件-拖拽', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (31, 20, 2, '文字滚动', 'TextScroll', 'text-scroll', '/widgets/text-scroll', '', 'ri:input-method-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 41, 1, '组件-文字滚动', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (32, 20, 2, '烟花', 'Fireworks', 'fireworks', '/widgets/fireworks', '', 'ri:magic-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 42, 1, '组件-烟花', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (33, 20, 2, '外链-ElementUI', 'ElementUI', 'elementui', '', '', 'ri:apps-2-line', 0, 0, '', 'https://element-plus.org/zh-CN/component/overview.html', '', 1, 0, 0, '', '', 0, 0, 43, 1, '组件-外链', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (40, 0, 1, '功能示例', 'Examples', '/examples', '/index/index', '', 'ri:sparkling-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 50, 1, '示例根', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (41, 40, 1, '权限示例', 'Permission', 'permission', '', '', 'ri:fingerprint-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 51, 1, '示例-权限', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (42, 41, 2, '切换角色', 'PermissionSwitchRole', 'switch-role', '/examples/permission/switch-role', '', 'ri:contacts-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 52, 1, '权限-切换角色', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (43, 41, 2, '按钮权限', 'PermissionButtonAuth', 'button-auth', '/examples/permission/button-auth', '', 'ri:mouse-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 53, 1, '权限-按钮', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (44, 41, 2, '页面可见性', 'PermissionPageVisibility', 'page-visibility', '/examples/permission/page-visibility', '', 'ri:user-3-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 54, 1, '权限-可见性', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (45, 40, 2, '多标签页', 'Tabs', 'tabs', '/examples/tabs', '', 'ri:price-tag-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 55, 1, '示例-标签', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (46, 40, 2, '表格基础', 'TablesBasic', 'tables-basic', '/examples/tables/basic', '', 'ri:layout-grid-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 56, 1, '示例-表格基础', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (47, 40, 2, '表格综合', 'Tables', 'tables', '/examples/tables', '', 'ri:table-3', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 57, 1, '示例-表格综合', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (48, 40, 2, '表单综合', 'Forms', 'forms', '/examples/forms', '', 'ri:table-view', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 58, 1, '示例-表单', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (49, 40, 2, '搜索栏', 'SearchBar', 'search-bar', '/examples/forms/search-bar', '', 'ri:table-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 59, 1, '示例-搜索栏', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (50, 40, 2, '树表格', 'TablesTree', 'tables-tree', '/examples/tables/tree', '', 'ri:layout-2-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 60, 1, '示例-树表', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (51, 40, 2, 'Socket 聊天', 'SocketChat', 'socket-chat', '/examples/socket-chat', '', 'ri:shake-hands-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 61, 1, '示例-聊天', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (60, 0, 1, '系统管理', 'System', '/system', '/index/index', '', 'ri:settings-3-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 70, 1, '系统设置和配置', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (61, 140, 2, '后台用户', 'User', 'user', '/system/user', 'admin_user', 'ri:user-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 3, 1, '后台用户管理', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (62, 140, 2, '角色管理', 'Role', 'role', '/system/role', 'admin_role', 'ri:user-settings-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 4, 1, '角色权限管理', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (63, 60, 2, '用户中心', 'UserCenter', 'user-center', '/system/user-center', '', 'ri:user-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 1, 1, '系统-用户中心', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (64, 140, 2, '菜单管理', 'Menus', 'menu', '/system/menu', 'admin_menu', 'ri:menu-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 5, 1, '菜单权限管理', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (65, 60, 2, '系统设置', 'SystemConfig', 'config', '/system/config', 'sys_config', 'ri:settings-3-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 2, 1, '', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (66, 60, 1, '多级菜单', 'Nested', 'nested', '', '', 'ri:menu-unfold-3-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 10, 1, '系统-嵌套', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (67, 66, 2, '菜单1', 'NestedMenu1', 'menu1', '/system/nested/menu1', '', 'ri:align-justify', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 77, 1, '嵌套-1', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (68, 66, 1, '菜单2', 'NestedMenu2', 'menu2', '', '', 'ri:align-justify', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 78, 1, '嵌套-2', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (69, 68, 2, '菜单2-1', 'NestedMenu2-1', 'menu2-1', '/system/nested/menu2', '', 'ri:align-justify', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 79, 1, '嵌套-2-1', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (70, 66, 1, '菜单3', 'NestedMenu3', 'menu3', '', '', 'ri:align-justify', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 80, 1, '嵌套-3', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (71, 70, 2, '菜单3-1', 'NestedMenu3-1', 'menu3-1', '/system/nested/menu3', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 81, 1, '嵌套-3-1', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (72, 70, 1, '菜单3-2', 'NestedMenu3-2', 'menu3-2', '', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 82, 1, '嵌套-3-2', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (73, 72, 2, '菜单3-2-1', 'NestedMenu3-2-1', 'menu3-2-1', '/system/nested/menu3/menu3-2', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 83, 1, '嵌套-3-2-1', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (80, 0, 1, '内容管理', 'Cms', '/cms', '/index/index', '', 'ri:article-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 85, 1, '内容管理根', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (81, 80, 2, '文档分类', 'CmsDocCategory', 'doc-category', '/cms/doc-category', '', 'ri:folder-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 1, 1, '文档分类管理', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (82, 80, 2, '文档管理', 'CmsDoc', 'doc', '/cms/doc', '', 'ri:file-text-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 2, 1, '文档内容管理', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (83, 82, 3, '新增/编辑', 'CmsDocSave', '', '', '', '', 0, 0, '', '', '/admin/cms/doc/save', 0, 0, 0, '', '', 0, 0, 1, 1, '新增或编辑文档', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (84, 82, 3, '删除', 'CmsDocDelete', '', '', '', '', 0, 0, '', '', '/admin/cms/doc/delete', 0, 0, 0, '', '', 0, 0, 2, 1, '删除文档', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (85, 81, 3, '新增/编辑', 'CmsDocCategorySave', '', '', '', '', 0, 0, '', '', '/admin/cms/docCategory/save', 0, 0, 0, '', '', 0, 0, 1, 1, '新增或编辑分类', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (86, 81, 3, '删除', 'CmsDocCategoryDelete', '', '', '', '', 0, 0, '', '', '/admin/cms/docCategory/delete', 0, 0, 0, '', '', 0, 0, 2, 1, '删除分类', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (90, 0, 1, '结果页', 'Result', '/result', '/index/index', '', 'ri:checkbox-circle-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 100, 1, '结果根', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (91, 90, 2, '成功页', 'ResultSuccess', 'success', '/result/success', '', 'ri:checkbox-circle-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 101, 1, '结果-成功', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (92, 90, 2, '失败页', 'ResultFail', 'fail', '/result/fail', '', 'ri:close-circle-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 102, 1, '结果-失败', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (100, 0, 1, '异常页', 'Exception', '/exception', '/index/index', '', 'ri:error-warning-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 110, 1, '异常根', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (101, 100, 2, '403', 'Exception403', '403', '/exception/403', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 111, 1, '异常-403', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (102, 100, 2, '404', 'Exception404', '404', '/exception/404', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 112, 1, '异常-404', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (103, 100, 2, '500', 'Exception500', '500', '/exception/500', '', '', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 113, 1, '异常-500', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (110, 0, 1, '运维管理', 'Safeguard', '/safeguard', '/index/index', '', 'ri:shield-check-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 120, 1, '运维根', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (111, 110, 2, '服务器监控', 'SafeguardServer', 'server', '/safeguard/server', '', 'ri:hard-drive-3-line', 0, 1, '', '', '["GET /admin/monitor/server"]', 0, 0, 0, '', '', 0, 0, 121, 1, '运维-服务器', 0, 0, 1768549363, 1770644180);

INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (122, 60, 2, '附件管理', 'system/attachment', 'system/attachment', '/system/attachment/index', 'sys_attachment', 'ep:folder-opened', 0, 1, '', '', NULL, 0, 0, 0, '', '', 0, 0, 3, 1, '附件中心与文件管理', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (123, 122, 3, '查看', 'system/attachment/index', '', '', '', '', 0, 0, '', '', 'system:attachment:list', 0, 0, 0, '', '', 0, 0, 1, 1, '', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (124, 122, 3, '编辑', 'system/attachment/edit', '', '', '', '', 0, 0, '', '', 'system:attachment:edit', 0, 0, 0, '', '', 0, 0, 2, 1, '', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (125, 122, 3, '删除', 'system/attachment/del', '', '', '', '', 0, 0, '', '', 'system:attachment:del', 0, 0, 0, '', '', 0, 0, 3, 1, '', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (126, 20, 2, '图标选择器', 'IconSelector', 'icon-selector', '/widgets/icon-selector', '', 'ri:palette-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 33, 1, '图标选择器组件', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (127, 20, 2, '颜色选择器', 'ColorPicker', 'color-picker', '/widgets/color-picker', '', 'ri:palette-fill', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 34, 1, '颜色选择器组件', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (128, 20, 2, '图片上传', 'ImageUpload', 'image-upload', '/widgets/image-upload', '', 'ri:image-2-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 35, 1, '图片上传组件', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (129, 20, 2, '文件上传', 'FileUpload', 'file-upload', '/widgets/file-upload', '', 'ri:file-upload-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 36, 1, '文件上传组件', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (130, 20, 2, '数组编辑器', 'ArrayEditor', 'array-editor', '/widgets/array-editor', '', 'ri:list-settings-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 37, 1, '多维数组编辑器组件', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (140, 0, 1, '权限管理', 'Auth', '/auth', '/index/index', '', 'ri:admin-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 65, 1, '权限管理模块', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (141, 140, 2, '部门管理', 'Dept', 'dept', '/system/dept', 'admin_dept', 'ri:organization-chart', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 1, 1, '组织架构和部门管理', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (142, 140, 2, '岗位管理', 'Post', 'post', '/system/post', 'admin_post', 'ri:briefcase-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 2, 1, '岗位管理（职位字典）', 0, 0, 1768549363, 1768549363);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (143, 0, 1, '会员管理', 'Member', '/member', '', '', 'ri:user-star-line', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 50, 1, '', 0, 0, 1768748969, 1768748969);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (144, 143, 2, '会员列表', 'MemberList', 'list', '/member/list/index', '', 'ri:team-line', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 10, 1, '', 0, 0, 1768748969, 1768748969);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (145, 143, 3, '添加会员', 'MemberAdd', '', '', '', '', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 1, 1, '', 0, 0, 1768748969, 1768748969);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (146, 143, 3, '编辑会员', 'MemberEdit', '', '', '', '', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 2, 1, '', 0, 0, 1768748969, 1768748969);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (147, 143, 3, '删除会员', 'MemberDelete', '', '', '', '', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 3, 1, '', 0, 0, 1768748969, 1768748969);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (148, 143, 3, '重置密码', 'MemberResetPassword', '', '', '', '', 0, 0, '', '', NULL, 0, 0, 0, '', '', 0, 0, 4, 1, '', 0, 0, 1768748969, 1768748969);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (149, 143, 2, '会员分组', 'MemberGroup', 'group', '/member/group/index', 'member_group', 'ri:group-line', 0, 1, '', '', '["POST /admin/member/group/list"]', 0, 0, 0, '', '', 0, 0, 20, 1, '会员分组管理', 0, 0, 1768791091, 1768791091);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (150, 149, 3, '新增分组', 'MemberGroupAdd', '', '', 'member_group', '', 0, 0, '', '', '["POST /admin/member/group/save"]', 0, 0, 0, '', '', 0, 0, 1, 1, '新增会员分组', 0, 0, 1768791091, 1768791091);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (151, 149, 3, '编辑分组', 'MemberGroupEdit', '', '', 'member_group', '', 0, 0, '', '', '["POST /admin/member/group/save"]', 0, 0, 0, '', '', 0, 0, 2, 1, '编辑会员分组', 0, 0, 1768791091, 1768791091);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (152, 149, 3, '删除分组', 'MemberGroupDelete', '', '', 'member_group', '', 0, 0, '', '', '["POST /admin/member/group/delete"]', 0, 0, 0, '', '', 0, 0, 3, 1, '删除会员分组', 0, 0, 1768791091, 1768791091);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (153, 143, 2, '会员菜单', 'MemberMenu', 'menu', '/member/menu/index', 'member_menu', 'ri:menu-line', 0, 1, '', '', '["GET /admin/member/menu/tree"]', 0, 0, 0, '', '', 0, 0, 30, 1, '会员前台菜单管理', 0, 0, 1768791091, 1768791091);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (154, 153, 3, '新增菜单', 'MemberMenuAdd', '', '', 'member_menu', '', 0, 0, '', '', '["POST /admin/member/menu/save"]', 0, 0, 0, '', '', 0, 0, 1, 1, '新增会员菜单', 0, 0, 1768791091, 1768791091);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (155, 153, 3, '编辑菜单', 'MemberMenuEdit', '', '', 'member_menu', '', 0, 0, '', '', '["POST /admin/member/menu/save"]', 0, 0, 0, '', '', 0, 0, 2, 1, '编辑会员菜单', 0, 0, 1768791091, 1768791091);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (156, 153, 3, '删除菜单', 'MemberMenuDelete', '', '', 'member_menu', '', 0, 0, '', '', '["POST /admin/member/menu/delete"]', 0, 0, 0, '', '', 0, 0, 3, 1, '删除会员菜单', 0, 0, 1768791091, 1768791091);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (157, 110, 2, '登录日志', 'LoginLog', 'login-log', '/safeguard/login-log', 'admin_login_log', 'ri:login-box-line', 0, 1, '', '', '["POST /admin/log/login/list"]', 0, 0, 0, '', '', 0, 0, 122, 1, '管理员登录日志', 0, 0, 1770615724, 1770615724);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (158, 157, 3, '删除日志', 'LoginLogDelete', '', '', 'admin_login_log', '', 0, 0, '', '', '["POST /admin/log/login/delete"]', 0, 0, 0, '', '', 0, 0, 1, 1, '删除登录日志', 0, 0, 1770615724, 1770615724);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (159, 157, 3, '清空日志', 'LoginLogClear', '', '', 'admin_login_log', '', 0, 0, '', '', '["POST /admin/log/login/clear"]', 0, 0, 0, '', '', 0, 0, 2, 1, '清空登录日志', 0, 0, 1770615724, 1770615724);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (160, 110, 2, '操作日志', 'OperationLog', 'operation-log', '/safeguard/operation-log', 'admin_operation_log', 'ri:file-text-line', 0, 1, '', '', '["POST /admin/log/operation/list"]', 0, 0, 0, '', '', 0, 0, 123, 1, '管理员操作日志', 0, 0, 1770615724, 1770615724);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (161, 160, 3, '查看详情', 'OperationLogDetail', '', '', 'admin_operation_log', '', 0, 0, '', '', '["GET /admin/log/operation/detail"]', 0, 0, 0, '', '', 0, 0, 1, 1, '查看操作日志详情', 0, 0, 1770615724, 1770615724);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (162, 160, 3, '删除日志', 'OperationLogDelete', '', '', 'admin_operation_log', '', 0, 0, '', '', '["POST /admin/log/operation/delete"]', 0, 0, 0, '', '', 0, 0, 2, 1, '删除操作日志', 0, 0, 1770615724, 1770615724);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (163, 160, 3, '清空日志', 'OperationLogClear', '', '', 'admin_operation_log', '', 0, 0, '', '', '["POST /admin/log/operation/clear"]', 0, 0, 0, '', '', 0, 0, 3, 1, '清空操作日志', 0, 0, 1770615724, 1770615724);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (164, 110, 2, '性能分析', 'SafeguardPerformance', 'performance', '/safeguard/performance', 'admin_operation_log', 'ri:line-chart-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 124, 1, '', 0, 0, 1770644179, 1770644179);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (165, 0, 1, '开发工具', 'Develop', '/develop', '/index/index', '', 'ri:code-box-line', 0, 0, '', '', '', 0, 0, 0, '', '', 0, 0, 125, 1, '开发工具目录', 0, 0, 1770648637, 1770648637);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (166, 165, 2, '代码生成器', 'GenCodes', 'gen-codes', '/develop/gen-codes/index', 'sys_gen_codes', 'ri:magic-line', 0, 1, '', '', '["GET /admin/genCodes/selects","GET /admin/genCodes/tableSelect","GET /admin/genCodes/columnList","GET /admin/genCodes/list","GET /admin/genCodes/view","POST /admin/genCodes/edit","POST /admin/genCodes/delete","POST /admin/genCodes/preview","POST /admin/genCodes/build","POST /admin/genCodes/createTable"]', 0, 0, 0, '', '', 0, 0, 1, 1, '代码生成器', 0, 0, 1770648637, 1770648637);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (202, 110, 2, '函数分析', 'PprofAnalysis', 'pprof', '/safeguard/pprof/index', '', 'ri:code-s-slash-line', 0, 1, '', '', '["GET /admin/monitor/pprof-top"]', 0, 0, 0, '', '', 0, 0, 125, 1, '函数级CPU/内存热点分析(pprof)', 0, 0, 1770702712, 1770702712);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (220, 60, 2, '通知管理', 'Notice', 'notice', '/system/notice/index', 'admin_notice', 'ri:notification-3-line', 0, 1, '', '', '["POST /admin/notice/list"]', 0, 0, 0, '', '', 0, 0, 4, 1, '通知消息管理', 0, 0, 1770700000, 1770700000);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (221, 220, 3, '查看', 'NoticeView', '', '', 'admin_notice', '', 0, 0, '', '', '["POST /admin/notice/list"]', 0, 0, 0, '', '', 0, 0, 1, 1, '查看通知列表', 0, 0, 1770700000, 1770700000);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (222, 220, 3, '发布/编辑', 'NoticeEdit', '', '', 'admin_notice', '', 0, 0, '', '', '["POST /admin/notice/edit"]', 0, 0, 0, '', '', 0, 0, 2, 1, '发布或编辑通知', 0, 0, 1770700000, 1770700000);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (223, 220, 3, '删除', 'NoticeDelete', '', '', 'admin_notice', '', 0, 0, '', '', '["POST /admin/notice/delete"]', 0, 0, 0, '', '', 0, 0, 3, 1, '删除通知', 0, 0, 1770700000, 1770700000);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (240, 60, 2, '定时任务', 'CronManage', 'cron', '/system/cron/index', 'sys_cron', 'ri:timer-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 80, 1, '定时任务管理', 0, 0, 1770717535, 1770717535);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (241, 240, 3, '查看', 'CronView', '', '', '', '', 0, 0, '', '', 'GET /admin/cron/list', 0, 0, 0, '', '', 0, 0, 0, 1, '', 0, 0, 1770717535, 1770717535);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (242, 240, 3, '新增/编辑', 'CronEdit', '', '', '', '', 0, 0, '', '', 'POST /admin/cron/save', 0, 0, 0, '', '', 0, 0, 0, 1, '', 0, 0, 1770717535, 1770717535);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (243, 240, 3, '删除', 'CronDelete', '', '', '', '', 0, 0, '', '', 'POST /admin/cron/delete', 0, 0, 0, '', '', 0, 0, 0, 1, '', 0, 0, 1770717535, 1770717535);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (244, 240, 3, '在线执行', 'CronOnlineExec', '', '', '', '', 0, 0, '', '', 'POST /admin/cron/onlineExec', 0, 0, 0, '', '', 0, 0, 0, 1, '', 0, 0, 1770717535, 1770717535);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (250, 60, 2, '消息队列', 'QueueManage', 'queue', '/system/queue/index', '', 'ri:stack-line', 0, 1, '', '', '', 0, 0, 0, '', '', 0, 0, 85, 1, '消息队列管理', 0, 0, 1770719034, 1770719034);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (418, 143, 2, '登录日志', 'MemberLoginLog', 'member-login-log', '/member/member-login-log/index', '', 'ri:file-list-line', 0, 1, '', '', '["GET /admin/member-login-log/list"]', 0, 0, 0, '', '', 0, 0, 100, 1, '', 0, 0, 1770873777, 1770873777);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (419, 418, 3, '查看登录日志', 'MemberLoginLogView', '', '', '', '', 0, 0, '', '', '["GET /admin/member-login-log/view"]', 0, 0, 0, '', '', 0, 0, 1, 1, '', 0, 0, 1770873777, 1770873777);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (420, 143, 2, '登录日志详情', 'MemberLoginLogDetail', 'member-login-log/detail', '/member/member-login-log/detail/index', '', '', 1, 0, '', '', '["GET /admin/member-login-log/view"]', 0, 0, 0, '', '/member-login-log', 0, 0, 0, 1, '', 0, 0, 1770873777, 1770873777);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (421, 418, 3, '删除登录日志', 'MemberLoginLogDelete', '', '', '', '', 0, 0, '', '', '["POST /admin/member-login-log/delete"]', 0, 0, 0, '', '', 0, 0, 4, 1, '', 0, 0, 1770873777, 1770873777);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (422, 418, 3, '导出登录日志', 'MemberLoginLogExport', '', '', '', '', 0, 0, '', '', '["GET /admin/member-login-log/export"]', 0, 0, 0, '', '', 0, 0, 5, 1, '', 0, 0, 1770873777, 1770873777);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (511, 143, 2, '余额变动日志', 'MemberMoneyLog', 'member-money-log', '/member/member-money-log/index', '', 'ri:file-list-line', 0, 1, '', '', '["GET /admin/member-money-log/list"]', 0, 0, 0, '', '', 0, 0, 100, 1, '', 0, 0, 1770881561, 1770881561);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (512, 511, 3, '查看余额变动日志', 'MemberMoneyLogView', '', '', '', '', 0, 0, '', '', '["GET /admin/member-money-log/view"]', 0, 0, 0, '', '', 0, 0, 1, 1, '', 0, 0, 1770881561, 1770881561);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (513, 511, 3, '新增余额变动日志', 'MemberMoneyLogAdd', '', '', '', '', 0, 0, '', '', '["POST /admin/member-money-log/edit"]', 0, 0, 0, '', '', 0, 0, 2, 1, '', 0, 0, 1770881561, 1770881561);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (514, 511, 3, '编辑余额变动日志', 'MemberMoneyLogEdit', '', '', '', '', 0, 0, '', '', '["POST /admin/member-money-log/edit","GET /admin/member-money-log/view"]', 0, 0, 0, '', '', 0, 0, 3, 1, '', 0, 0, 1770881561, 1770881561);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (515, 511, 3, '删除余额变动日志', 'MemberMoneyLogDelete', '', '', '', '', 0, 0, '', '', '["POST /admin/member-money-log/delete"]', 0, 0, 0, '', '', 0, 0, 4, 1, '', 0, 0, 1770881561, 1770881561);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (516, 511, 3, '导出余额变动日志', 'MemberMoneyLogExport', '', '', '', '', 0, 0, '', '', '["GET /admin/member-money-log/export"]', 0, 0, 0, '', '', 0, 0, 5, 1, '', 0, 0, 1770881561, 1770881561);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (517, 143, 2, '积分变动日志', 'MemberScoreLog', 'member-score-log', '/member/member-score-log/index', '', 'ri:file-list-line', 0, 1, '', '', '["GET /admin/member-score-log/list"]', 0, 0, 0, '', '', 0, 0, 100, 1, '', 0, 0, 1770881700, 1770881700);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (617, 143, 2, '会员通知', 'MemberNotice', 'member-notice', '/member/member-notice/index', '', 'ri:notification-line', 0, 1, '', '', '["GET /admin/member-notice/list"]', 0, 0, 0, '', '', 0, 0, 100, 1, '', 0, 0, 1770904531, 1770904531);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (618, 617, 3, '查看会员通知', 'MemberNoticeView', '', '', '', '', 0, 0, '', '', '["GET /admin/member-notice/view"]', 0, 0, 0, '', '', 0, 0, 1, 1, '', 0, 0, 1770904531, 1770904531);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (619, 617, 3, '新增会员通知', 'MemberNoticeAdd', '', '', '', '', 0, 0, '', '', '["POST /admin/member-notice/edit"]', 0, 0, 0, '', '', 0, 0, 2, 1, '', 0, 0, 1770904531, 1770904531);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (620, 617, 3, '编辑会员通知', 'MemberNoticeEdit', '', '', '', '', 0, 0, '', '', '["POST /admin/member-notice/edit","GET /admin/member-notice/view"]', 0, 0, 0, '', '', 0, 0, 3, 1, '', 0, 0, 1770904531, 1770904531);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (621, 617, 3, '删除会员通知', 'MemberNoticeDelete', '', '', '', '', 0, 0, '', '', '["POST /admin/member-notice/delete"]', 0, 0, 0, '', '', 0, 0, 4, 1, '', 0, 0, 1770904531, 1770904531);
INSERT INTO public.xy_admin_menu (id, parent_id, type, title, name, path, component, resource, icon, hidden, keep_alive, redirect, frame_src, perms, is_frame, affix, show_badge, badge_text, active_path, hide_tab, is_full_page, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (622, 617, 3, '导出会员通知', 'MemberNoticeExport', '', '', '', '', 0, 0, '', '', '["GET /admin/member-notice/export"]', 0, 0, 0, '', '', 0, 0, 5, 1, '', 0, 0, 1770904531, 1770904531);


--
-- Data for Name: xy_admin_notice; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_notice (id, title, type, content, tag, sender_id, receiver_id, status, sort, remark, read_count, created_at, updated_at) VALUES (1, 'test a notify', 1, '我来了', 'info', 1, 0, 1, 0, '', 2, 1770706024, 1770708972);


--
-- Data for Name: xy_admin_notice_read; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_notice_read (id, notice_id, user_id, read_at) VALUES (1, 1, 1, 1770706027);
INSERT INTO public.xy_admin_notice_read (id, notice_id, user_id, read_at) VALUES (2, 1, 2, 1770708972);


--
-- Data for Name: xy_admin_operation_log; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (831, 1, 'admin', '操作日志', '清空日志', 'POST', '/admin/log/operation/clear', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '', '', '', 1, 111, 1770909791);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (832, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 30, 1770909794);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (833, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 176, 1770909794);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (834, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770909800);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (835, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 4, 1770909800);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (836, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770909808);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (837, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 1, 1770909808);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (838, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 2, 1770909880);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (839, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 4, 1770909880);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (840, 1, 'admin', '登录日志', '清空日志', 'POST', '/admin/log/login/clear', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '', '', '', 1, 109, 1770909944);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (841, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 11, 1770909994);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (842, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 17, 1770909994);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (843, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 8, 1770910322);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (844, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 6, 1770910322);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (845, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 11, 1770910322);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (846, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 7, 1770910322);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (847, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 2, 1770910353);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (848, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 5, 1770910353);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (849, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770910356);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (850, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 7, 1770910356);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (851, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 0, 1770910357);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (852, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 2, 1770910357);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (853, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 4, 1770910370);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (854, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 5, 1770910370);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (855, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 13, 1770910370);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (856, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 12, 1770910370);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (857, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 0, 1770910387);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (858, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 2, 1770910387);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (859, 1, 'admin', 'menu', 'POST /admin/menu/save', 'POST', '/admin/menu/save', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":164,"parentId":110,"type":2,"title":"性能分析","name":"SafeguardPerformance","path":"performance","component":"/safeguard/performance","icon":"ri:line-chart-line","resource":"admin_operation_log","hidden":0,"hideTab":0,"keepAlive":0,"redirect":"","frameSrc":"","perms":"","isFrame":0,"affix":0,"showBadge":0,"badgeText":"","activePath":"","isFullPage":0,"sort":124,"status":1,"remark":""}', '', '', 1, 94, 1770910442);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (860, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770910448);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (861, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 5, 1770910448);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (862, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770910471);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (863, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 2, 1770910472);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (864, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770910477);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (865, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 17, 1770910477);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (866, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770910481);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (867, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 3, 1770910481);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (868, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 0, 1770910485);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (869, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 3, 1770910485);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (870, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 3, 1770910509);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (871, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 2, 1770910509);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (872, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770910511);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (873, 1, 'admin', '运维管理', '性能分析', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 1, 1770910511);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (874, 1, 'admin', '会员通知', '编辑会员通知', 'POST', '/admin/member-notice/edit', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":0,"title":"test a notify","content":"<p>这是一个测试通知</p>","type":"system","target":"all","targetId":0,"sender":"Xygo","status":1}', '', '', 1, 59, 1770910671);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (875, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/delete', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":39,"deleteFiles":true,"deleteMenus":true}', '', '', 1, 139, 1770911898);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (876, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/delete', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":38,"deleteFiles":true,"deleteMenus":true}', '', '', 1, 75, 1770911907);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (899, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770912670);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (900, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 3, 1770912670);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (877, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/preview', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":0,"genType":10,"dbName":"","tableName":"xy_test_code","tableComment":"测试生成","varName":"TestCode","options":"{\"genType\":10,\"headOps\":[\"add\",\"batchDel\",\"export\"],\"columnOps\":[\"edit\",\"del\",\"view\",\"status\",\"check\"],\"autoOps\":[\"genMenuPermissions\",\"runDao\",\"runService\"],\"viewMode\":\"drawer\",\"apiPrefix\":\"\",\"genPaths\":{},\"menu\":{\"pid\":0,\"icon\":\"ri:file-list-line\",\"sort\":100},\"tree\":{\"titleColumn\":\"name\",\"pidColumn\":\"parent_id\"}}","columns":[{"id":0,"genId":0,"name":"id","goName":"Id","tsName":"id","dbType":"bigint(20) unsigned","goType":"uint64","tsType":"number","comment":"主键","isPk":1,"isRequired":0,"isList":1,"isEdit":0,"isQuery":0,"queryType":"eq","formType":"input","designType":"pk","extra":"","dictType":"","sort":1},{"id":0,"genId":0,"name":"name","goName":"Name","tsName":"name","dbType":"varchar(100)","goType":"string","tsType":"string","comment":"名称","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":1,"queryType":"like","formType":"input","designType":"string","extra":"","dictType":"","sort":2},{"id":0,"genId":0,"name":"member_id","goName":"MemberId","tsName":"memberId","dbType":"int(10) unsigned","goType":"uint","tsType":"number","comment":"关联ID","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":0,"queryType":"eq","formType":"remoteSelect","designType":"remoteSelect","extra":"{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"remote-table\":\"xy_member_login_log\",\"remote-pk\":\"id\",\"remote-field\":\"username\",\"relation-fields-config\":\"[{\\\"field\\\":\\\"id\\\",\\\"label\\\":\\\"ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"member_id\\\",\\\"label\\\":\\\"会员ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"username\\\",\\\"label\\\":\\\"用户名\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"ip\\\",\\\"label\\\":\\\"登录IP\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"user_agent\\\",\\\"label\\\":\\\"User-Agent\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"status\\\",\\\"label\\\":\\\"状态\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"message\\\",\\\"label\\\":\\\"提示信息\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"created_at\\\",\\\"label\\\":\\\"创建时间\\\",\\\"inList\\\":true,\\\"inSearch\\\":true,\\\"inExport\\\":true,\\\"searchType\\\":\\\"between\\\",\\\"searchComponent\\\":\\\"datetimerange\\\",\\\"listRender\\\":\\\"text\\\"}]\",\"relation-fields\":\"created_at\",\"relation-search-fields\":\"created_at\",\"relation-export-fields\":\"created_at\"},\"_tableProps\":{\"render\":\"none\",\"operator\":\"eq\",\"sortable\":\"false\"}}","dictType":"","sort":3}]}', '', '', 1, 12, 1770911986);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (878, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/edit', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":0,"genType":10,"dbName":"","tableName":"xy_test_code","tableComment":"测试生成","varName":"TestCode","options":"{\"genType\":10,\"headOps\":[\"add\",\"batchDel\",\"export\"],\"columnOps\":[\"edit\",\"del\",\"view\",\"status\",\"check\"],\"autoOps\":[\"genMenuPermissions\",\"runDao\",\"runService\"],\"viewMode\":\"drawer\",\"apiPrefix\":\"\",\"genPaths\":{},\"menu\":{\"pid\":0,\"icon\":\"ri:file-list-line\",\"sort\":100},\"tree\":{\"titleColumn\":\"name\",\"pidColumn\":\"parent_id\"}}","columns":[{"id":0,"genId":0,"name":"id","goName":"Id","tsName":"id","dbType":"bigint(20) unsigned","goType":"uint64","tsType":"number","comment":"主键","isPk":1,"isRequired":0,"isList":1,"isEdit":0,"isQuery":0,"queryType":"eq","formType":"input","designType":"pk","extra":"","dictType":"","sort":1},{"id":0,"genId":0,"name":"name","goName":"Name","tsName":"name","dbType":"varchar(100)","goType":"string","tsType":"string","comment":"名称","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":1,"queryType":"like","formType":"input","designType":"string","extra":"","dictType":"","sort":2},{"id":0,"genId":0,"name":"member_id","goName":"MemberId","tsName":"memberId","dbType":"int(10) unsigned","goType":"uint","tsType":"number","comment":"关联ID","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":0,"queryType":"eq","formType":"remoteSelect","designType":"remoteSelect","extra":"{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"remote-table\":\"xy_member_login_log\",\"remote-pk\":\"id\",\"remote-field\":\"username\",\"relation-fields-config\":\"[{\\\"field\\\":\\\"id\\\",\\\"label\\\":\\\"ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"member_id\\\",\\\"label\\\":\\\"会员ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"username\\\",\\\"label\\\":\\\"用户名\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"ip\\\",\\\"label\\\":\\\"登录IP\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"user_agent\\\",\\\"label\\\":\\\"User-Agent\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"status\\\",\\\"label\\\":\\\"状态\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"message\\\",\\\"label\\\":\\\"提示信息\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"created_at\\\",\\\"label\\\":\\\"创建时间\\\",\\\"inList\\\":true,\\\"inSearch\\\":true,\\\"inExport\\\":true,\\\"searchType\\\":\\\"between\\\",\\\"searchComponent\\\":\\\"datetimerange\\\",\\\"listRender\\\":\\\"text\\\"}]\",\"relation-fields\":\"created_at\",\"relation-search-fields\":\"created_at\",\"relation-export-fields\":\"created_at\"},\"_tableProps\":{\"render\":\"none\",\"operator\":\"eq\",\"sortable\":\"false\"}}","dictType":"","sort":3}]}', '', '', 1, 59, 1770911988);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (879, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/build', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":0,"genType":10,"dbName":"","tableName":"xy_test_code","tableComment":"测试生成","varName":"TestCode","options":"{\"genType\":10,\"headOps\":[\"add\",\"batchDel\",\"export\"],\"columnOps\":[\"edit\",\"del\",\"view\",\"status\",\"check\"],\"autoOps\":[\"genMenuPermissions\",\"runDao\",\"runService\"],\"viewMode\":\"drawer\",\"apiPrefix\":\"\",\"genPaths\":{},\"menu\":{\"pid\":0,\"icon\":\"ri:file-list-line\",\"sort\":100},\"tree\":{\"titleColumn\":\"name\",\"pidColumn\":\"parent_id\"}}","columns":[{"id":0,"genId":0,"name":"id","goName":"Id","tsName":"id","dbType":"bigint(20) unsigned","goType":"uint64","tsType":"number","comment":"主键","isPk":1,"isRequired":0,"isList":1,"isEdit":0,"isQuery":0,"queryType":"eq","formType":"input","designType":"pk","extra":"","dictType":"","sort":1},{"id":0,"genId":0,"name":"name","goName":"Name","tsName":"name","dbType":"varchar(100)","goType":"string","tsType":"string","comment":"名称","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":1,"queryType":"like","formType":"input","designType":"string","extra":"","dictType":"","sort":2},{"id":0,"genId":0,"name":"member_id","goName":"MemberId","tsName":"memberId","dbType":"int(10) unsigned","goType":"uint","tsType":"number","comment":"关联ID","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":0,"queryType":"eq","formType":"remoteSelect","designType":"remoteSelect","extra":"{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"remote-table\":\"xy_member_login_log\",\"remote-pk\":\"id\",\"remote-field\":\"username\",\"relation-fields-config\":\"[{\\\"field\\\":\\\"id\\\",\\\"label\\\":\\\"ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"member_id\\\",\\\"label\\\":\\\"会员ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"username\\\",\\\"label\\\":\\\"用户名\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"ip\\\",\\\"label\\\":\\\"登录IP\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"user_agent\\\",\\\"label\\\":\\\"User-Agent\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"status\\\",\\\"label\\\":\\\"状态\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"message\\\",\\\"label\\\":\\\"提示信息\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"created_at\\\",\\\"label\\\":\\\"创建时间\\\",\\\"inList\\\":true,\\\"inSearch\\\":true,\\\"inExport\\\":true,\\\"searchType\\\":\\\"between\\\",\\\"searchComponent\\\":\\\"datetimerange\\\",\\\"listRender\\\":\\\"text\\\"}]\",\"relation-fields\":\"created_at\",\"relation-search-fields\":\"created_at\",\"relation-export-fields\":\"created_at\"},\"_tableProps\":{\"render\":\"none\",\"operator\":\"eq\",\"sortable\":\"false\"}}","dictType":"","sort":3}]}', '', '', 1, 636, 1770911989);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (880, 1, 'admin', 'genCodes', 'POST /admin/genCodes/publishFrontend', 'POST', '/admin/genCodes/publishFrontend', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '', '', '', 1, 15, 1770911998);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (881, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/delete', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":68,"deleteFiles":true,"deleteMenus":true}', '', 'DELETE FROM `xy_sys_gen_codes` WHERE `id`=68: context canceled', 0, 132, 1770912378);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (882, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/preview', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":0,"genType":10,"dbName":"","tableName":"xy_test_code","tableComment":"测试生成","varName":"TestCode","options":"{\"genType\":10,\"headOps\":[\"add\",\"batchDel\",\"export\"],\"columnOps\":[\"edit\",\"del\",\"view\",\"status\",\"check\"],\"autoOps\":[\"genMenuPermissions\",\"runDao\",\"runService\"],\"viewMode\":\"drawer\",\"apiPrefix\":\"\",\"genPaths\":{},\"menu\":{\"pid\":0,\"icon\":\"ri:file-list-line\",\"sort\":100},\"tree\":{\"titleColumn\":\"name\",\"pidColumn\":\"parent_id\"}}","columns":[{"id":0,"genId":0,"name":"id","goName":"Id","tsName":"id","dbType":"bigint(20) unsigned","goType":"uint64","tsType":"number","comment":"主键","isPk":1,"isRequired":0,"isList":1,"isEdit":0,"isQuery":0,"queryType":"eq","formType":"input","designType":"pk","extra":"","dictType":"","sort":1},{"id":0,"genId":0,"name":"name","goName":"Name","tsName":"name","dbType":"varchar(100)","goType":"string","tsType":"string","comment":"名称","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":1,"queryType":"like","formType":"input","designType":"string","extra":"","dictType":"","sort":2},{"id":0,"genId":0,"name":"member_id","goName":"MemberId","tsName":"memberId","dbType":"int(10) unsigned","goType":"uint","tsType":"number","comment":"关联ID","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":0,"queryType":"eq","formType":"remoteSelect","designType":"remoteSelect","extra":"{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"remote-table\":\"xy_member\",\"remote-pk\":\"id\",\"remote-field\":\"nickname\",\"relation-fields-config\":\"[{\\\"field\\\":\\\"id\\\",\\\"label\\\":\\\"会员ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"username\\\",\\\"label\\\":\\\"用户名\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"password\\\",\\\"label\\\":\\\"密码（bcrypt加密）\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"mobile\\\",\\\"label\\\":\\\"手机号\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"email\\\",\\\"label\\\":\\\"邮箱\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"nickname\\\",\\\"label\\\":\\\"昵称\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"avatar\\\",\\\"label\\\":\\\"头像\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"gender\\\",\\\"label\\\":\\\"性别\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"birthday\\\",\\\"label\\\":\\\"生日\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"money\\\",\\\"label\\\":\\\"余额\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"score\\\",\\\"label\\\":\\\"积分\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"level\\\",\\\"label\\\":\\\"会员等级\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"group_id\\\",\\\"label\\\":\\\"会员分组ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"status\\\",\\\"label\\\":\\\"状态\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"last_login_ip\\\",\\\"label\\\":\\\"最后登录IP\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchCompo...(truncated)', '', '', 1, 16, 1770912448);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (901, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 3, 1770912755);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (902, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 5, 1770912755);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (903, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770912760);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (904, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 3, 1770912760);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (883, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/edit', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":0,"genType":10,"dbName":"","tableName":"xy_test_code","tableComment":"测试生成","varName":"TestCode","options":"{\"genType\":10,\"headOps\":[\"add\",\"batchDel\",\"export\"],\"columnOps\":[\"edit\",\"del\",\"view\",\"status\",\"check\"],\"autoOps\":[\"genMenuPermissions\",\"runDao\",\"runService\"],\"viewMode\":\"drawer\",\"apiPrefix\":\"\",\"genPaths\":{},\"menu\":{\"pid\":0,\"icon\":\"ri:file-list-line\",\"sort\":100},\"tree\":{\"titleColumn\":\"name\",\"pidColumn\":\"parent_id\"}}","columns":[{"id":0,"genId":0,"name":"id","goName":"Id","tsName":"id","dbType":"bigint(20) unsigned","goType":"uint64","tsType":"number","comment":"主键","isPk":1,"isRequired":0,"isList":1,"isEdit":0,"isQuery":0,"queryType":"eq","formType":"input","designType":"pk","extra":"","dictType":"","sort":1},{"id":0,"genId":0,"name":"name","goName":"Name","tsName":"name","dbType":"varchar(100)","goType":"string","tsType":"string","comment":"名称","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":1,"queryType":"like","formType":"input","designType":"string","extra":"","dictType":"","sort":2},{"id":0,"genId":0,"name":"member_id","goName":"MemberId","tsName":"memberId","dbType":"int(10) unsigned","goType":"uint","tsType":"number","comment":"关联ID","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":0,"queryType":"eq","formType":"remoteSelect","designType":"remoteSelect","extra":"{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"remote-table\":\"xy_member\",\"remote-pk\":\"id\",\"remote-field\":\"nickname\",\"relation-fields-config\":\"[{\\\"field\\\":\\\"id\\\",\\\"label\\\":\\\"会员ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"username\\\",\\\"label\\\":\\\"用户名\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"password\\\",\\\"label\\\":\\\"密码（bcrypt加密）\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"mobile\\\",\\\"label\\\":\\\"手机号\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"email\\\",\\\"label\\\":\\\"邮箱\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"nickname\\\",\\\"label\\\":\\\"昵称\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"avatar\\\",\\\"label\\\":\\\"头像\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"gender\\\",\\\"label\\\":\\\"性别\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"birthday\\\",\\\"label\\\":\\\"生日\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"money\\\",\\\"label\\\":\\\"余额\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"score\\\",\\\"label\\\":\\\"积分\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"level\\\",\\\"label\\\":\\\"会员等级\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"group_id\\\",\\\"label\\\":\\\"会员分组ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"status\\\",\\\"label\\\":\\\"状态\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"last_login_ip\\\",\\\"label\\\":\\\"最后登录IP\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchCompo...(truncated)', '', '', 1, 76, 1770912450);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (884, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/build', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":0,"genType":10,"dbName":"","tableName":"xy_test_code","tableComment":"测试生成","varName":"TestCode","options":"{\"genType\":10,\"headOps\":[\"add\",\"batchDel\",\"export\"],\"columnOps\":[\"edit\",\"del\",\"view\",\"status\",\"check\"],\"autoOps\":[\"genMenuPermissions\",\"runDao\",\"runService\"],\"viewMode\":\"drawer\",\"apiPrefix\":\"\",\"genPaths\":{},\"menu\":{\"pid\":0,\"icon\":\"ri:file-list-line\",\"sort\":100},\"tree\":{\"titleColumn\":\"name\",\"pidColumn\":\"parent_id\"}}","columns":[{"id":0,"genId":0,"name":"id","goName":"Id","tsName":"id","dbType":"bigint(20) unsigned","goType":"uint64","tsType":"number","comment":"主键","isPk":1,"isRequired":0,"isList":1,"isEdit":0,"isQuery":0,"queryType":"eq","formType":"input","designType":"pk","extra":"","dictType":"","sort":1},{"id":0,"genId":0,"name":"name","goName":"Name","tsName":"name","dbType":"varchar(100)","goType":"string","tsType":"string","comment":"名称","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":1,"queryType":"like","formType":"input","designType":"string","extra":"","dictType":"","sort":2},{"id":0,"genId":0,"name":"member_id","goName":"MemberId","tsName":"memberId","dbType":"int(10) unsigned","goType":"uint","tsType":"number","comment":"关联ID","isPk":0,"isRequired":1,"isList":1,"isEdit":1,"isQuery":0,"queryType":"eq","formType":"remoteSelect","designType":"remoteSelect","extra":"{\"_formProps\":{\"validator\":[],\"validatorMsg\":\"\",\"remote-table\":\"xy_member\",\"remote-pk\":\"id\",\"remote-field\":\"nickname\",\"relation-fields-config\":\"[{\\\"field\\\":\\\"id\\\",\\\"label\\\":\\\"会员ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"username\\\",\\\"label\\\":\\\"用户名\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"password\\\",\\\"label\\\":\\\"密码（bcrypt加密）\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"mobile\\\",\\\"label\\\":\\\"手机号\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"email\\\",\\\"label\\\":\\\"邮箱\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"nickname\\\",\\\"label\\\":\\\"昵称\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"avatar\\\",\\\"label\\\":\\\"头像\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"gender\\\",\\\"label\\\":\\\"性别\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"birthday\\\",\\\"label\\\":\\\"生日\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"money\\\",\\\"label\\\":\\\"余额\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"score\\\",\\\"label\\\":\\\"积分\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"level\\\",\\\"label\\\":\\\"会员等级\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"group_id\\\",\\\"label\\\":\\\"会员分组ID\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"status\\\",\\\"label\\\":\\\"状态\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchComponent\\\":\\\"input\\\",\\\"listRender\\\":\\\"text\\\"},{\\\"field\\\":\\\"last_login_ip\\\",\\\"label\\\":\\\"最后登录IP\\\",\\\"inList\\\":false,\\\"inSearch\\\":false,\\\"inExport\\\":false,\\\"searchType\\\":\\\"like\\\",\\\"searchCompo...(truncated)', '', '', 1, 564, 1770912451);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (885, 1, 'admin', 'genCodes', 'POST /admin/genCodes/publishFrontend', 'POST', '/admin/genCodes/publishFrontend', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '', '', '', 1, 15, 1770912461);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (886, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 3, 1770912511);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (887, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 4, 1770912511);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (888, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770912525);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (889, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 3, 1770912525);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (890, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 0, 1770912528);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (891, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 2, 1770912528);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (892, 1, 'admin', 'menu', 'POST /admin/menu/save', 'POST', '/admin/menu/save', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":164,"parentId":110,"type":2,"title":"性能分析","name":"SafeguardPerformance","path":"performance","component":"/safeguard/performance","icon":"ri:line-chart-line","resource":"admin_operation_log","hidden":0,"hideTab":0,"keepAlive":0,"redirect":"","frameSrc":"","perms":"","isFrame":0,"affix":0,"showBadge":0,"badgeText":"","activePath":"","isFullPage":0,"sort":124,"status":1,"remark":""}', '', '', 1, 3, 1770912625);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (893, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 2, 1770912649);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (894, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 2, 1770912649);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (895, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770912654);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (896, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 2, 1770912654);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (897, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 2, 1770912659);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (898, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 3, 1770912659);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (905, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770912765);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (906, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 3, 1770912765);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (907, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770912768);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (908, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 4, 1770912768);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (909, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 2, 1770912807);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (910, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 5, 1770912807);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (911, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770912811);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (912, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 3, 1770912811);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (913, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770912816);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (914, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 5, 1770912816);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (915, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770912830);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (916, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 5, 1770912830);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (917, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 2, 1770913038);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (918, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 4, 1770913038);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (919, 1, 'admin', 'monitor', 'POST /admin/monitor/slow-top', 'POST', '/admin/monitor/slow-top', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12","limit":20}', '', '', 1, 1, 1770913041);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (920, 1, 'admin', 'monitor', 'POST /admin/monitor/stats', 'POST', '/admin/monitor/stats', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"startDate":"2026-02-12","endDate":"2026-02-12"}', '', '', 1, 3, 1770913041);
INSERT INTO public.xy_admin_operation_log (id, user_id, username, module, title, method, url, ip, location, user_agent, request_body, response_body, error_message, status, elapsed, created_at) VALUES (921, 1, 'admin', '开发工具', '代码生成器', 'POST', '/admin/genCodes/delete', '127.0.0.1', '本机', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', '{"id":68,"deleteFiles":true,"deleteMenus":true}', '', '', 1, 163, 1770913411);


--
-- Data for Name: xy_admin_post; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_post (id, code, name, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (1, 'CEO', '董事长', 1, 1, '公司最高管理者', 0, 0, 1768556833, 1768556833);
INSERT INTO public.xy_admin_post (id, code, name, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (2, 'CTO', '技术总监', 2, 1, '技术部门负责人', 0, 0, 1768556833, 1768556833);
INSERT INTO public.xy_admin_post (id, code, name, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (3, 'CFO', '财务总监', 3, 1, '财务部门负责人', 0, 0, 1768556833, 1768556833);
INSERT INTO public.xy_admin_post (id, code, name, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (4, 'PM', '产品经理', 4, 1, '产品规划与设计', 0, 0, 1768556833, 1768556833);
INSERT INTO public.xy_admin_post (id, code, name, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (5, 'DEV', '开发工程师', 5, 1, '软件开发', 0, 0, 1768556833, 1768556833);
INSERT INTO public.xy_admin_post (id, code, name, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (6, 'QA', '测试工程师', 6, 1, '质量保证', 0, 0, 1768556833, 1768556833);
INSERT INTO public.xy_admin_post (id, code, name, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (7, 'UI', 'UI设计师', 7, 1, '用户界面设计', 0, 0, 1768556833, 1768556833);


--
-- Data for Name: xy_admin_role; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_role (id, name, key, data_scope, custom_depts, pid, level, tree, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (1, '超级管理员', 'super_admin', 0, '[]', 0, 1, '0', 0, 1, '系统内置超级管理员11', 1, 0, 1768560139, 1768560139);
INSERT INTO public.xy_admin_role (id, name, key, data_scope, custom_depts, pid, level, tree, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (2, '运维管理员', 'ops_admin', 2, '[]', 1, 2, '0,1', 0, 1, '负责运维与系统配置', 1, 0, 1768560139, 1768560139);
INSERT INTO public.xy_admin_role (id, name, key, data_scope, custom_depts, pid, level, tree, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (3, '业务管理员', 'biz_admin', 1, '[]', 1, 2, '0,1', 0, 1, '负责业务数据管理', 1, 0, 1768560139, 1768560139);
INSERT INTO public.xy_admin_role (id, name, key, data_scope, custom_depts, pid, level, tree, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (4, '访客', 'viewer', 3, '', 3, 3, '0,1,3', 0, 1, '只读访问权限', 1, 0, 1768560139, 1768560139);
INSERT INTO public.xy_admin_role (id, name, key, data_scope, custom_depts, pid, level, tree, sort, status, remark, created_by, updated_by, create_time, update_time) VALUES (5, '测试二号管理员', 'node_add', 0, '[]', 1, 2, '0,1', 0, 1, '一个测试管理员', 0, 0, 1768560139, 1768560139);


--
-- Data for Name: xy_admin_role_menu; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 1);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (4, 1);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 2);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (4, 2);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 3);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (4, 3);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 4);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (4, 4);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (4, 61);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 80);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 81);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 82);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 83);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 84);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 110);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 111);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (4, 122);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (4, 123);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (4, 124);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (4, 125);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (4, 141);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 144);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 157);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 158);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 159);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 160);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 161);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 162);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 163);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 164);
INSERT INTO public.xy_admin_role_menu (role_id, menu_id) VALUES (2, 202);


--
-- Data for Name: xy_admin_user; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_user (id, username, nickname, real_name, password, gender, salt, mobile, address, remark, email, avatar, dept_id, pid, is_super, status, last_login_at, last_login_ip, created_by, updated_by, create_time, update_time) VALUES (1, 'admin', '超级管理员', '系统管理员', 'e10adc3949ba59abbe56e057f20f883e', 1, '', '15524812851', '辽宁省-大连市-开发区', '一个又懒又爱又帅气得男人', '751300685@qq.com', '/attachment/upload/20260210/2c2ddd0e-e4b2-4b76-ba31-1d992de4e0d7.webp', 0, 0, 1, 1, NULL, '', 0, 0, 1768575212, 1768575212);
INSERT INTO public.xy_admin_user (id, username, nickname, real_name, password, gender, salt, mobile, address, remark, email, avatar, dept_id, pid, is_super, status, last_login_at, last_login_ip, created_by, updated_by, create_time, update_time) VALUES (2, 'admin2', '测试用户2', NULL, '7e8bc594d2dfd02d6ba7b51aa34d839e', 1, 'AwDVkR', '15241328852', NULL, NULL, 'aaaa@qq.com', '', 2, 0, 0, 1, NULL, '', 1, 1, 1770708367, 1770708956);
INSERT INTO public.xy_admin_user (id, username, nickname, real_name, password, gender, salt, mobile, address, remark, email, avatar, dept_id, pid, is_super, status, last_login_at, last_login_ip, created_by, updated_by, create_time, update_time) VALUES (3, 'testzong', '测试总公司', NULL, '222ea6a32ab043cf11315020d5a828f9', 1, 'eSDG3M', '13895281214', NULL, NULL, 'aaa@qq.com', '', 1, 0, 0, 1, NULL, '', 1, 1, 1770711284, 1770711284);
INSERT INTO public.xy_admin_user (id, username, nickname, real_name, password, gender, salt, mobile, address, remark, email, avatar, dept_id, pid, is_super, status, last_login_at, last_login_ip, created_by, updated_by, create_time, update_time) VALUES (4, 'xingxing', '星韵', NULL, '38a82d3031b16b189ef047fdd897c331', 1, '6lmWUd', '13898521473', NULL, NULL, 'bbb@qq.com', '/attachment/upload/20260210/0a27edcc-e96c-4b2e-95f9-b69c772cde82.webp', 5, 0, 0, 1, NULL, '', 1, 1, 1770711602, 1770711828);


--
-- Data for Name: xy_admin_user_post; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_user_post (user_id, post_id) VALUES (2, 2);
INSERT INTO public.xy_admin_user_post (user_id, post_id) VALUES (3, 1);
INSERT INTO public.xy_admin_user_post (user_id, post_id) VALUES (4, 2);


--
-- Data for Name: xy_admin_user_role; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_admin_user_role (user_id, role_id) VALUES (1, 1);
INSERT INTO public.xy_admin_user_role (user_id, role_id) VALUES (2, 1);
INSERT INTO public.xy_admin_user_role (user_id, role_id) VALUES (3, 1);
INSERT INTO public.xy_admin_user_role (user_id, role_id) VALUES (4, 1);


--
-- Data for Name: xy_captcha; Type: TABLE DATA; Schema: xygonew; Owner: -
--



--
-- Data for Name: xy_demo_article; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_demo_article (id, category_id, title, cover, summary, content, author, views, sort, status, created_at, updated_at) VALUES (1, 3, 'Vue3 组合式API指南', '/attachment/upload/20260117/995f9919-23d3-4ce2-8564-2460e4b1261d.webp', '', '', '张三', 100, 1, 1, 1770653552, 1770868163);
INSERT INTO public.xy_demo_article (id, category_id, title, cover, summary, content, author, views, sort, status, created_at, updated_at) VALUES (2, 4, 'GoFrame 入门教程', '/attachment/upload/20260117/995f9919-23d3-4ce2-8564-2460e4b1261d.webp', '', '', '李四', 200, 2, 1, 1770653552, 1770868156);
INSERT INTO public.xy_demo_article (id, category_id, title, cover, summary, content, author, views, sort, status, created_at, updated_at) VALUES (3, 5, '家常菜做法', '/attachment/upload/20260210/2c2ddd0e-e4b2-4b76-ba31-1d992de4e0d7.webp', '', '', '王五', 50, 3, 1, 1770653552, 1770868145);


--
-- Data for Name: xy_demo_category; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_demo_category (id, parent_id, name, icon, sort, status, remark, created_at, updated_at) VALUES (1, 0, '技术', 'ri:dashboard-fill', 1, 1, '技术类文章', 1770653552, 1770812776);
INSERT INTO public.xy_demo_category (id, parent_id, name, icon, sort, status, remark, created_at, updated_at) VALUES (2, 0, '生活', 'ri:heart-line', 2, 1, '生活类文章', 1770653552, 1770653552);
INSERT INTO public.xy_demo_category (id, parent_id, name, icon, sort, status, remark, created_at, updated_at) VALUES (3, 1, '前端', 'ri:html5-line', 1, 1, '前端技术', 1770653552, 1770653552);
INSERT INTO public.xy_demo_category (id, parent_id, name, icon, sort, status, remark, created_at, updated_at) VALUES (4, 1, '后端', 'ri:server-line', 2, 1, '后端技术', 1770653552, 1770653552);
INSERT INTO public.xy_demo_category (id, parent_id, name, icon, sort, status, remark, created_at, updated_at) VALUES (5, 2, '美食', 'ri:restaurant-line', 1, 1, '美食分享', 1770653552, 1770653552);


--
-- Data for Name: xy_member; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_member (id, username, password, salt, mobile, email, nickname, avatar, gender, birthday, money, score, level, group_id, status, last_login_ip, last_login_at, login_count, created_at, updated_at, deleted_at) VALUES (1, 'user', '4c0648b0fe19879ee68a5a08899e2296', 'jf8gU6', '', '751300685@qq.com', '751300685', '/attachment/upload/20260212/cc679f09-57e9-4c35-9054-65e4afde8cd3.png', 0, NULL, 0.00, 11, 1, 1, 1, '127.0.0.1', 1770909732, 11, 1770908432, 1770913381, 0);


--
-- Data for Name: xy_member_checkin; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_member_checkin (id, member_id, checkin_date, score, continuous_days, created_at) VALUES (1, 1, NULL, 5, 1, NULL);
INSERT INTO public.xy_member_checkin (id, member_id, checkin_date, score, continuous_days, created_at) VALUES (2, 1, 1770910155, 4, 1, 1770910155);
INSERT INTO public.xy_member_checkin (id, member_id, checkin_date, score, continuous_days, created_at) VALUES (3, 1, 1770913381, 2, 2, 1770913381);


--
-- Data for Name: xy_member_group; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_member_group (id, name, rules, status, sort, remark, created_at, updated_at) VALUES (1, '普通会员', '*', 1, 0, '默认分组', 1770908749, 1770908749);
INSERT INTO public.xy_member_group (id, name, rules, status, sort, remark, created_at, updated_at) VALUES (2, 'VIP会员', '1,2,3,4,5', 1, 10, 'VIP用户', 1770908749, 1770908749);





--
-- Data for Name: xy_member_menu; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_member_menu (id, pid, title, name, path, component, icon, menu_type, url, no_login_valid, extend, remark, type, nav_show_children, permission, sort, status, created_at, updated_at) VALUES (1, 0, '文档', 'docs', '/docs', 'docs/index', 'ri:book-open-line', 'tab', '', 1, 'none', '', 'nav', 0, '', 10, 1, NULL, NULL);
INSERT INTO public.xy_member_menu (id, pid, title, name, path, component, icon, menu_type, url, no_login_valid, extend, remark, type, nav_show_children, permission, sort, status, created_at, updated_at) VALUES (4, 0, '我的账户', 'account', '/user', '', 'ri:user-line', 'tab', '', 0, 'none', '', 'menu_dir', 0, '', 100, 1, NULL, NULL);
INSERT INTO public.xy_member_menu (id, pid, title, name, path, component, icon, menu_type, url, no_login_valid, extend, remark, type, nav_show_children, permission, sort, status, created_at, updated_at) VALUES (5, 4, '账户概览', 'overview', '/user/overview', 'member/center', 'ri:home-4-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 101, 1, NULL, NULL);
INSERT INTO public.xy_member_menu (id, pid, title, name, path, component, icon, menu_type, url, no_login_valid, extend, remark, type, nav_show_children, permission, sort, status, created_at, updated_at) VALUES (6, 4, '每日签到', 'checkin', '/user/checkin', 'member/center', 'ri:calendar-check-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 102, 1, NULL, NULL);
INSERT INTO public.xy_member_menu (id, pid, title, name, path, component, icon, menu_type, url, no_login_valid, extend, remark, type, nav_show_children, permission, sort, status, created_at, updated_at) VALUES (7, 4, '个人资料', 'profile', '/user/profile', 'member/center', 'ri:user-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 103, 1, NULL, NULL);
INSERT INTO public.xy_member_menu (id, pid, title, name, path, component, icon, menu_type, url, no_login_valid, extend, remark, type, nav_show_children, permission, sort, status, created_at, updated_at) VALUES (8, 4, '修改密码', 'password', '/user/password', 'member/center', 'ri:shield-keyhole-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 104, 1, NULL, NULL);
INSERT INTO public.xy_member_menu (id, pid, title, name, path, component, icon, menu_type, url, no_login_valid, extend, remark, type, nav_show_children, permission, sort, status, created_at, updated_at) VALUES (9, 4, '积分记录', 'points', '/user/points', 'member/center', 'ri:copper-coin-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 105, 1, NULL, NULL);
INSERT INTO public.xy_member_menu (id, pid, title, name, path, component, icon, menu_type, url, no_login_valid, extend, remark, type, nav_show_children, permission, sort, status, created_at, updated_at) VALUES (10, 4, '余额记录', 'balance', '/user/balance', 'member/center', 'ri:wallet-3-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 106, 1, NULL, NULL);
INSERT INTO public.xy_member_menu (id, pid, title, name, path, component, icon, menu_type, url, no_login_valid, extend, remark, type, nav_show_children, permission, sort, status, created_at, updated_at) VALUES (11, 4, '系统通知', 'notification', '/user/notification', 'member/center', 'ri:notification-3-line', 'tab', '', 0, 'none', '', 'menu', 0, '', 107, 1, NULL, NULL);


--
-- Data for Name: xy_member_money_log; Type: TABLE DATA; Schema: xygonew; Owner: -
--



--
-- Data for Name: xy_member_notice; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_member_notice (id, title, content, type, target, target_id, sender, status, created_at) VALUES (1, '欢迎使用 XYGo Admin', '感谢您注册成为我们的会员！您可以在会员中心管理个人信息、查看积分和余额变动记录。每天记得签到领取积分哦！', 'system', 'all', 0, '系统', 1, 1770908749);
INSERT INTO public.xy_member_notice (id, title, content, type, target, target_id, sender, status, created_at) VALUES (2, '每日签到功能上线', '全新的每日签到功能现已上线！每日签到可获得随机积分奖励，连续签到天数越多，奖励越丰厚。快来试试吧！', 'feature', 'all', 0, '系统', 1, 1770908749);
INSERT INTO public.xy_member_notice (id, title, content, type, target, target_id, sender, status, created_at) VALUES (3, 'test a notify', '<p>这是一个测试通知</p>', 'system', 'all', 0, 'Xygo', 1, 1770910671);


--
-- Data for Name: xy_member_notice_read; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_member_notice_read (id, notice_id, member_id, read_at) VALUES (1, 2, 1, NULL);
INSERT INTO public.xy_member_notice_read (id, notice_id, member_id, read_at) VALUES (2, 1, 1, NULL);
INSERT INTO public.xy_member_notice_read (id, notice_id, member_id, read_at) VALUES (3, 3, 1, 1770910685);


--
-- Data for Name: xy_member_score_log; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_member_score_log (id, member_id, score, before, after, memo, created_at) VALUES (1, 1, 5, 0, 5, '每日签到奖励', 1770908749);
INSERT INTO public.xy_member_score_log (id, member_id, score, before, after, memo, created_at) VALUES (2, 1, 4, 5, 9, '每日签到奖励', 1770910155);
INSERT INTO public.xy_member_score_log (id, member_id, score, before, after, memo, created_at) VALUES (3, 1, 2, 9, 11, '每日签到奖励', 1770913381);


--
-- Data for Name: xy_sys_attachment; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_sys_attachment (id, topic, user_id, url, width, height, name, size, mimetype, quote, storage, sha1, create_time, update_time) VALUES (2, 'image', 1, '/attachment/upload/20260117/995f9919-23d3-4ce2-8564-2460e4b1261d.webp', 0, 0, '单独logo (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1768618131, 1768618131);
INSERT INTO public.xy_sys_attachment (id, topic, user_id, url, width, height, name, size, mimetype, quote, storage, sha1, create_time, update_time) VALUES (3, 'image', 1, '/attachment/upload/20260210/b17249d2-0d9d-496d-a6a5-1c9c2c603459.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770710651, 1770710651);
INSERT INTO public.xy_sys_attachment (id, topic, user_id, url, width, height, name, size, mimetype, quote, storage, sha1, create_time, update_time) VALUES (4, 'image', 1, '/attachment/upload/20260210/19c3332f-d5db-44f6-bb69-c406e7f4c974.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770711566, 1770711566);
INSERT INTO public.xy_sys_attachment (id, topic, user_id, url, width, height, name, size, mimetype, quote, storage, sha1, create_time, update_time) VALUES (5, 'image', 1, '/attachment/upload/20260210/5d77559d-27e2-4bec-8ed3-c4ea22f4e032.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770711611, 1770711611);
INSERT INTO public.xy_sys_attachment (id, topic, user_id, url, width, height, name, size, mimetype, quote, storage, sha1, create_time, update_time) VALUES (6, 'image', 1, '/attachment/upload/20260210/e1469abb-5c58-42a1-b487-4f07d4efcfd2.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770711730, 1770711730);
INSERT INTO public.xy_sys_attachment (id, topic, user_id, url, width, height, name, size, mimetype, quote, storage, sha1, create_time, update_time) VALUES (7, 'image', 1, '/attachment/upload/20260210/0a27edcc-e96c-4b2e-95f9-b69c772cde82.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770711822, 1770711822);
INSERT INTO public.xy_sys_attachment (id, topic, user_id, url, width, height, name, size, mimetype, quote, storage, sha1, create_time, update_time) VALUES (8, 'image', 1, '/attachment/upload/20260210/2c2ddd0e-e4b2-4b76-ba31-1d992de4e0d7.webp', 0, 0, '单独logo (1) (1).webp', 4138, 'image/webp', 1, 'local', 'b58012c1219a7a5f09248f01d73daa8cd077f597', 1770738480, 1770738480);


--
-- Data for Name: xy_sys_config; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (1, 'basics', '基础设置', '站点名称', 'site_name', 'XYGo Admin', 'text', NULL, '{"max": 50, "required": true}', 10, '后台标题/LOGO文字', 0, 0, 0, 0, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (2, 'basics', '基础设置', '站点副标题', 'site_subtitle', '下一代 GoFrame 管理后台', 'text', NULL, '{"max": 100}', 11, '登录页/浏览器标题副文案', 0, 0, 0, 0, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (3, 'basics', '基础设置', 'ICP备案号', 'site_icp', '粤ICP备000000号', 'text', NULL, '{"max": 50}', 20, '展示在页脚的备案号', 0, 0, 0, 0, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (4, 'basics', '基础设置', '站点时区', 'site_timezone', 'Asia/Shanghai', 'select', '{"options": [{"label": "上海(Asia/Shanghai)", "value": "Asia/Shanghai"}, {"label": "UTC", "value": "UTC"}]}', '{"required": true}', 30, '影响时间显示/日志默认时区', 0, 0, 0, 0, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (5, 'basics', '基础设置', '是否关闭站点', 'site_closed', '0', 'switch', NULL, '{"required": true}', 40, '1=关闭，0=正常访问', 0, 0, 0, 0, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (6, 'mail', '邮件配置', 'SMTP 主机', 'smtp_host', 'smtp.example.com', 'text', NULL, '{"required": true}', 10, '邮件服务器地址', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (7, 'mail', '邮件配置', 'SMTP 端口', 'smtp_port', '465', 'number', NULL, '{"required": true}', 20, '常见为 25/465/587', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (8, 'mail', '邮件配置', 'SSL 加密', 'smtp_secure', '1', 'switch', NULL, '{"required": true}', 30, '1=启用 SSL，0=关闭', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (9, 'mail', '邮件配置', '发件人邮箱', 'smtp_user', 'noreply@example.com', 'text', NULL, '{"required": true}', 40, '用作登录用户名/From 地址', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (10, 'mail', '邮件配置', '发件邮箱密码', 'smtp_pass', '', 'text', NULL, '{"required": true}', 50, 'SMTP 授权码或密码', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (11, 'oss', '对象存储', '存储驱动', 'oss_driver', 'local', 'select', '{"options": [{"label": "本地", "value": "local"}, {"label": "阿里云OSS", "value": "oss"}, {"label": "七牛云", "value": "qiniu"}, {"label": "腾讯云cos", "value": "cos"}]}', '{"required": true}', 10, '附件实际保存到哪里', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (13, 'security', '安全设置', '禁止访问 IP 列表', 'forbidden_ips', '["127.0.0.1"]', 'textarea', NULL, NULL, 10, '每行一个 IP，支持 CIDR，示例：192.168.0.1 或 10.0.0.0/24', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (14, 'security', '安全设置', '登录失败锁定次数', 'login_fail_max', '5', 'number', NULL, '{"required": true}', 20, '超过此次数可触发验证码/锁定策略', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (15, 'security', '安全设置', '登录验证码开关', 'login_captcha', '1', 'switch', NULL, '{"required": true}', 30, '1=开启验证码，0=关闭', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (16, 'basics', '基础设置', '站点说明', 'site_description', '这里是站点的简介文案，支持多行文本，用于 SEO 描述等。', 'textarea', NULL, '{"max": 300}', 50, '站点的详细介绍，前台可用作描述', 0, 0, 0, 0, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (17, 'basics', '基础设置', '主题主色调', 'theme_color', '#409EFF', 'color', '{"showAlpha": false}', NULL, 60, '前端主题主色，后续可用来生成主题变量', 0, 0, 0, 0, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (18, 'basics', '基础设置', '站点 LOGO', 'site_logo', '/attachment/upload/20260117/995f9919-23d3-4ce2-8564-2460e4b1261d.webp', 'image', '{"tip": "建议 200x200 PNG", "limit": 1, "accept": "image/*"}', NULL, 70, '后台左上角 LOGO 图片', 0, 0, 0, 0, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (19, 'security', '安全设置', '密码强度要求', 'password_level', 'medium', 'radio', '{"options": [{"label": "宽松", "value": "low"}, {"label": "中等", "value": "medium"}, {"label": "严格", "value": "high"}]}', '{"required": true}', 40, '影响密码最小长度、复杂度校验等', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (20, 'security', '安全设置', '登录防护策略', 'login_protect', '["ip_limit"]', 'checkbox', '{"options": [{"label": "限制 IP 白名单", "value": "ip_limit"}, {"label": "启用登录验证码", "value": "captcha"}, {"label": "限制同账号多地登录", "value": "multi_login_limit"}]}', NULL, 50, '多选组合策略，后续中间件可按值启用对应防护', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (23, 'basics', '基础设置', '示例三维数组', 'sample_array_3d', '[{"name":"张三","role":"admin","tags":["vue","react"],"avatar":"https://example.com/avatars/zhangsan.jpg"},{"name":"李四","role":"user","tags":["react"],"avatar":"https://example.com/avatars/lisi.jpg"}]', 'array', '{"fields": [{"key": "name", "type": "text", "label": "姓名", "placeholder": "请输入姓名"}, {"key": "role", "type": "select", "label": "角色", "options": [{"label": "管理员", "value": "admin"}, {"label": "用户", "value": "user"}, {"label": "访客", "value": "guest"}], "placeholder": "请选择角色"}, {"key": "tags", "type": "selects", "label": "标签", "options": [{"label": "Vue", "value": "vue"}, {"label": "React", "value": "react"}, {"label": "Angular", "value": "angular"}], "placeholder": "请选择标签"}, {"key": "avatar", "type": "image", "label": "头像", "maxSize": 5}]}', NULL, 99, '用于测试多维数组渲染（可在高级 JSON 模式查看）', 0, 0, 0, 0, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (24, 'security', '安全设置', '登录验证码模式', 'login_captcha_mode', 'qrcode', 'select', '{"options": [{"label": "短信", "value": "sms"}, {"label": "邮箱", "value": "email"}, {"label": "二维码", "value": "qrcode"}]}', NULL, 120, '单选下拉示例', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (25, 'security', '安全设置', '登录防护策略（多选）', 'login_protect_multi', '["ip_limit","captcha","multi_login_limit"]', 'selects', '{"options": [{"label": "限制 IP 白名单", "value": "ip_limit"}, {"label": "启用验证码", "value": "captcha"}, {"label": "限制同账号多地登录", "value": "multi_login_limit"}], "multiple": true}', NULL, 130, '多选下拉示例', 0, 0, 0, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (26, 'basics', '基础设置', '站点富文本', 'site_richtext', '<p>测试服务这回可以了吧真的好厉害</p>', 'editor', '{"mode": "default", "height": "360px", "placeholder": "请输入站点介绍...", "toolbarKeys": ["headerSelect", "bold", "underline", "italic", "through", "color", "bgColor", "link", "bulletedList", "numberedList", "todo", "justifyLeft", "justifyCenter", "justifyRight", "insertTable", "uploadImage", "codeBlock", "undo", "redo"], "uploadConfig": {"maxFileSize": 3145728, "maxNumberOfFiles": 5}}', NULL, 100, '富文本示例，使用 ArtWangEditor', 0, NULL, NULL, 0, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (27, 'basics', '基础设置', '站点富文本', 'site_textedio', '<p>啊啊啊啊</p>', 'editor', '{"mode": "default", "height": "360px", "placeholder": "请输入站点介绍...", "toolbarKeys": ["headerSelect", "bold", "underline", "italic", "through", "color", "bgColor", "link", "bulletedList", "numberedList", "todo", "justifyLeft", "justifyCenter", "justifyRight", "insertTable", "uploadImage", "codeBlock", "undo", "redo"], "uploadConfig": {"maxFileSize": 3145728, "maxNumberOfFiles": 5}}', NULL, 100, '富文本示例，使用 ArtWangEditor', 0, NULL, NULL, 0, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (28, 'dictionary', '字典配置', '配置分组字典', 'config_group', '[{"group":"basics","groupName":"基础设置","icon":"ri:settings-3-line","description":"系统常规信息配置","sort":0},{"group":"oss","groupName":"对象存储","icon":"ri:cloud-line","description":"对象存储配置","sort":10},{"group":"mail","groupName":"邮件配置","icon":"ri:mail-line","description":"邮箱账号信息配置","sort":20},{"group":"security","groupName":"安全设置","icon":"ri:shield-line","description":"安全相关配置","sort":30},{"group":"sms","groupName":"短信配置","icon":"ri:smartphone-line","description":"配置短信接口","sort":40},{"group":"we_mapp","groupName":"小程序配置","icon":"ri:wechat-fill","description":"微信小程序配置","sort":50},{"group":"we_oa","groupName":"公众号配置","icon":"ri:wechat-line","description":"微信公众号配置","sort":60}]', 'array', '{"fields": [{"key": "group", "type": "text", "label": "分组标识", "placeholder": "如 basics/mail/oss"}, {"key": "groupName", "type": "text", "label": "分组名称", "placeholder": "显示名称"}, {"key": "icon", "type": "text", "label": "图标", "placeholder": "如 ri:settings-3-line"}, {"key": "description", "type": "text", "label": "描述", "placeholder": "分组描述信息"}, {"key": "sort", "min": 0, "type": "number", "label": "排序", "placeholder": "越大越靠后"}]}', NULL, 10, '配置分组字典（key=group，value=显示名）', 0, NULL, NULL, 0, 1770736665);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (34, 'oss', '对象存储', '阿里云 endpoint', 'oss_aliyun_endpoint', '', 'text', NULL, NULL, 110, '如 oss-cn-hangzhou.aliyuncs.com', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (35, 'oss', '对象存储', '阿里云 AccessKeyId', 'oss_aliyun_access_key_id', '', 'text', NULL, NULL, 111, '', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (36, 'oss', '对象存储', '阿里云 AccessKeySecret', 'oss_aliyun_access_key_secret', '', 'text', NULL, NULL, 112, '', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (37, 'oss', '对象存储', '阿里云 bucket', 'oss_aliyun_bucket', '', 'text', NULL, NULL, 113, '', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (38, 'oss', '对象存储', '阿里云 domain', 'oss_aliyun_domain', '', 'text', NULL, NULL, 114, '建议配置为自定义域名/CDN，如 https://static.example.com', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (39, 'oss', '对象存储', '阿里云 root', 'oss_aliyun_root', '', 'text', NULL, NULL, 115, '可选，例如 uploads，留空则存根目录', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (40, 'oss', '对象存储', '七牛 AccessKey', 'oss_qiniu_access_key', '', 'text', NULL, NULL, 120, '', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (41, 'oss', '对象存储', '七牛 SecretKey', 'oss_qiniu_secret_key', '', 'text', NULL, NULL, 121, '', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (42, 'oss', '对象存储', '七牛 bucket', 'oss_qiniu_bucket', '', 'text', NULL, NULL, 122, '', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (43, 'oss', '对象存储', '七牛 domain', 'oss_qiniu_domain', '', 'text', NULL, NULL, 123, '绑定域名，如 https://img.xxx.com', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (44, 'oss', '对象存储', '七牛 root', 'oss_qiniu_root', '', 'text', NULL, NULL, 124, '可选，留空存根目录', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (45, 'oss', '对象存储', '七牛 zone', 'oss_qiniu_zone', '', 'text', NULL, NULL, 125, '可选，留空自动；如 z0/z1', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (46, 'oss', '对象存储', '七牛 uplink', 'oss_qiniu_uplink', '', 'text', NULL, NULL, 126, '可空', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (47, 'oss', '对象存储', 'COS SecretId', 'oss_cos_secret_id', '', 'text', NULL, NULL, 130, '', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (48, 'oss', '对象存储', 'COS SecretKey', 'oss_cos_secret_key', '', 'text', NULL, NULL, 131, '', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (49, 'oss', '对象存储', 'COS Region', 'oss_cos_region', '', 'text', NULL, NULL, 132, '如 ap-shanghai', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (50, 'oss', '对象存储', 'COS bucket', 'oss_cos_bucket', '', 'text', NULL, NULL, 133, '含 AppId，如 xxx-125xxxx', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (51, 'oss', '对象存储', 'COS domain', 'oss_cos_domain', '', 'text', NULL, NULL, 134, '可选自定义域名', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (52, 'oss', '对象存储', 'COS root', 'oss_cos_root', '', 'text', NULL, NULL, 135, '可选，留空存根目录', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (53, 'oss', '对象存储', 'COS schema', 'oss_cos_schema', '', 'text', NULL, NULL, 136, 'http 或 https，默认 https', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (54, 'oss', '对象存储', '单文件最大大小', 'upload_max_size', '10mb', 'text', NULL, NULL, 10, '支持 b、kb、mb、gb，例如 10mb', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (55, 'oss', '对象存储', '允许的文件后缀', 'upload_allowed_suffixes', 'jpg,png,bmp,jpeg,gif,webp,zip,rar,wav,mp4,mp3,docx', 'text', NULL, NULL, 11, '逗号分隔，小写字母', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (56, 'oss', '对象存储', '允许的MIME类型', 'upload_allowed_mime_types', '', 'text', NULL, NULL, 12, '留空表示不限制，例如 image/png,image/jpeg', 0, NULL, NULL, 0, 0);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (57, 'basics', '基础设置', '前台会员中心', 'open_member_center', '1', 'switch', '{"activeText": "", "activeValue": "1", "inactiveText": "", "inactiveValue": "0"}', NULL, 100, '如关闭则无法登录注册前台会员中心', 0, NULL, NULL, 1770736767, 1770737799);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (58, 'we_mapp', '小程序配置', '微信小程序appid', 'wmapp_appid', '', 'text', '{"pattern": "", "maxLength": 50, "minLength": 0, "placeholder": "请输入"}', NULL, 100, '微信小程序appid', 0, NULL, NULL, 1773624392, 1773624392);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (59, 'we_mapp', '小程序配置', '微信小程序appsecret', 'wmapp_secret', '', 'text', '{"pattern": "", "maxLength": 50, "minLength": 0, "placeholder": "请输入"}', NULL, 100, '', 0, NULL, NULL, 1773624417, 1773624417);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (60, 'we_oa', '公众号配置', '公众号AppID', 'weoa_appid', '', 'text', '{"pattern": "", "maxLength": 50, "minLength": 0, "placeholder": "请输入公众号AppID"}', NULL, 100, '微信公众号AppID', 0, NULL, NULL, 1773624417, 1773624417);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (61, 'we_oa', '公众号配置', '公众号AppSecret', 'weoa_secret', '', 'text', '{"pattern": "", "maxLength": 50, "minLength": 0, "placeholder": "请输入公众号AppSecret"}', NULL, 110, '微信公众号AppSecret', 0, NULL, NULL, 1773624417, 1773624417);
INSERT INTO public.xy_sys_config (id, "group", group_name, name, key, value, type, options, rules, sort, remark, allow_del, created_by, updated_by, create_time, update_time) VALUES (62, 'we_oa', '公众号配置', '公众号Token', 'weoa_token', '', 'text', '{"pattern": "", "maxLength": 100, "minLength": 0, "placeholder": "请输入公众号服务器Token"}', NULL, 120, '公众号服务器配置Token（用于消息验证）', 0, NULL, NULL, 1773624417, 1773624417);


--
-- Data for Name: xy_sys_cron; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_sys_cron (id, group_id, title, name, params, pattern, policy, count, sort, remark, status, created_at, updated_at) VALUES (1, 2, '测试定时任务', 'test', 'hello word', '*/5 * * * * *', 1, 1, 0, '一个测试范例定时任务', 0, 1770718404, 1770718450);
INSERT INTO public.xy_sys_cron (id, group_id, title, name, params, pattern, policy, count, sort, remark, status, created_at, updated_at) VALUES (2, 1, '监测队列状态', 'queue_alert', '5,1', '0 */5 * * * *', 1, 1, 0, '检测队列积压情况', 0, 1770720827, 1770725448);


--
-- Data for Name: xy_sys_cron_group; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_sys_cron_group (id, name, sort, remark, status, created_at, updated_at) VALUES (1, '系统任务', 0, '系统内置定时任务', 1, 1770716554, 1770716554);
INSERT INTO public.xy_sys_cron_group (id, name, sort, remark, status, created_at, updated_at) VALUES (2, '业务任务', 10, '业务自定义定时任务', 1, 1770716554, 1770716554);


--
-- Data for Name: xy_sys_cron_log; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (1, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:25] hello word', '', 0, 1770718405);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (2, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:30] hello word', '', 0, 1770718410);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (3, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:35] hello word', '', 0, 1770718415);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (4, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:40] hello word', '', 0, 1770718420);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (5, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:45] hello word', '', 0, 1770718425);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (6, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:50] hello word', '', 0, 1770718430);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (7, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:13:55] hello word', '', 0, 1770718435);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (8, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:14:00] hello word', '', 0, 1770718440);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (9, 1, 'test', '测试定时任务', 'hello word', 1, '[2026-02-10 18:14:05] hello word', '', 0, 1770718445);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (10, 2, 'queue_alert', 'queue_alert', '100,10', 1, 'all queues normal', '', 1, 1770720900);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (11, 2, 'queue_alert', 'queue_alert', '100,10', 1, 'all queues normal', '', 2, 1770721200);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (12, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 3, 1770721426);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (13, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 3, 1770721500);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (14, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 3, 1770721514);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (15, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 4, 1770721520);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (16, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 6, 1770721622);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (17, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 5, 1770721633);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (18, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 3, 1770721649);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (19, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 4, 1770721800);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (20, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 3, 1770722100);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (21, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 3, 1770722400);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (22, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 3, 1770722700);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (23, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 3, 1770723000);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (24, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 2, 1770723300);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (25, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 3, 1770723600);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (26, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 7, 1770723900);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (27, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 5, 1770724200);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (28, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 2, 1770724500);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (29, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 5, 1770724800);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (30, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 3, 1770725100);
INSERT INTO public.xy_sys_cron_log (id, cron_id, name, title, params, status, output, err_msg, take_ms, created_at) VALUES (31, 2, 'queue_alert', 'queue_alert', '5,1', 1, '告警 2 条，已推送给 1 位管理员:
队列 login_log 积压 7 条（阈值 5）
队列 login_log 死信 2 条（阈值 1）', '', 4, 1770725400);


--
-- Data for Name: xy_sys_gen_codes; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_sys_gen_codes (id, gen_type, db_name, table_name, table_comment, var_name, options, status, created_at, updated_at) VALUES (37, 10, 'xygonew', 'xy_member_login_log', '登录日志', 'MemberLoginLog', '{"menu": {"pid": 143, "icon": "ri:file-list-line", "sort": 100}, "tree": {"pidColumn": "parent_id", "titleColumn": "name"}, "autoOps": ["genMenuPermissions", "runDao", "runService"], "genType": 10, "headOps": ["batchDel", "export"], "genPaths": {}, "viewMode": "page", "apiPrefix": "", "columnOps": ["del", "view", "check"]}', 2, 1770873777, 1770873777);
INSERT INTO public.xy_sys_gen_codes (id, gen_type, db_name, table_name, table_comment, var_name, options, status, created_at, updated_at) VALUES (51, 10, 'xygonew', 'xy_member_money_log', '余额变动日志', 'MemberMoneyLog', '{"menu": {"pid": 143, "icon": "ri:file-list-line", "sort": 100}, "tree": {"pidColumn": "parent_id", "titleColumn": "name"}, "autoOps": ["genMenuPermissions", "runDao", "runService"], "genType": 10, "headOps": ["add", "batchDel", "export"], "genPaths": {}, "viewMode": "drawer", "apiPrefix": "", "columnOps": ["edit", "del", "view", "status", "check"], "modulePath": "member/member-money-log", "generatedFiles": {"server": ["E:\\xygoadmin\\server\\api\\admin\\admin_member_money_log.go", "E:\\xygoadmin\\server\\internal\\controller\\admin\\member_money_log.go", "E:\\xygoadmin\\server\\resource\\sql\\generate\\menu_member_money_log.sql", "E:\\xygoadmin\\server\\internal\\model\\input\\adminin\\member_money_log.go", "E:\\xygoadmin\\server\\internal\\logic\\membermoneylog\\member_money_log.go"], "frontend": ["E:\\xygoadmin\\newweb\\src\\api\\backend\\member\\member-money-log.ts", "E:\\xygoadmin\\newweb\\src\\views\\backend\\member\\member-money-log\\index.vue", "E:\\xygoadmin\\newweb\\src\\views\\backend\\member\\member-money-log\\modules\\member-money-log-dialog.vue", "E:\\xygoadmin\\newweb\\src\\views\\backend\\member\\member-money-log\\modules\\member-money-log-detail-drawer.vue", "E:\\xygoadmin\\newweb\\src\\views\\backend\\member\\member-money-log\\modules\\member-money-log-search.vue"]}}', 1, 1770881561, 1770881606);
INSERT INTO public.xy_sys_gen_codes (id, gen_type, db_name, table_name, table_comment, var_name, options, status, created_at, updated_at) VALUES (52, 10, 'xygonew', 'xy_member_score_log', '积分变动日志', 'MemberScoreLog', '{"menu": {"pid": 143, "icon": "ri:file-list-line", "sort": 100}, "tree": {"pidColumn": "parent_id", "titleColumn": "name"}, "autoOps": ["genMenuPermissions", "runDao", "runService"], "genType": 10, "headOps": ["add", "batchDel", "export"], "genPaths": {}, "viewMode": "drawer", "apiPrefix": "", "columnOps": ["edit", "del", "view", "status", "check"], "modulePath": "member/member-score-log", "generatedFiles": {"server": ["E:\\xygoadmin\\server\\api\\admin\\admin_member_score_log.go", "E:\\xygoadmin\\server\\internal\\controller\\admin\\member_score_log.go", "E:\\xygoadmin\\server\\resource\\sql\\generate\\menu_member_score_log.sql", "E:\\xygoadmin\\server\\internal\\model\\input\\adminin\\member_score_log.go", "E:\\xygoadmin\\server\\internal\\logic\\memberscorelog\\member_score_log.go"], "frontend": ["E:\\xygoadmin\\newweb\\src\\api\\backend\\member\\member-score-log.ts", "E:\\xygoadmin\\newweb\\src\\views\\backend\\member\\member-score-log\\index.vue", "E:\\xygoadmin\\newweb\\src\\views\\backend\\member\\member-score-log\\modules\\member-score-log-dialog.vue", "E:\\xygoadmin\\newweb\\src\\views\\backend\\member\\member-score-log\\modules\\member-score-log-detail-drawer.vue", "E:\\xygoadmin\\newweb\\src\\views\\backend\\member\\member-score-log\\modules\\member-score-log-search.vue"]}}', 1, 1770881700, 1770894898);
INSERT INTO public.xy_sys_gen_codes (id, gen_type, db_name, table_name, table_comment, var_name, options, status, created_at, updated_at) VALUES (67, 10, 'xygonew', 'xy_member_notice', '会员通知', 'MemberNotice', '{"menu": {"pid": 143, "icon": "ri:notification-line", "sort": 100}, "tree": {"pidColumn": "parent_id", "titleColumn": "name"}, "autoOps": ["genMenuPermissions", "runDao", "runService"], "genType": 10, "headOps": ["add", "batchDel", "export"], "genPaths": {}, "viewMode": "drawer", "apiPrefix": "", "columnOps": ["edit", "del", "view", "status", "check"]}', 2, 1770904531, 1770904531);


--
-- Data for Name: xy_sys_gen_codes_column; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (491, 37, 'id', 'Id', 'id', 'bigint(20) unsigned', 'uint64', 'number', 'ID', 1, 0, 1, 0, 0, 'eq', 'pk', '', 'input', '', 1);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (492, 37, 'member_id', 'MemberId', 'memberId', 'bigint(20) unsigned', 'uint64', 'number', '会员ID', 0, 1, 1, 1, 0, 'eq', 'remoteSelect', '{"_formProps":{"validator":[],"validatorMsg":"","remote-table":"xy_member","remote-pk":"id","remote-field":"username","relation-fields-config":"[{\"field\":\"id\",\"label\":\"会员ID\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"username\",\"label\":\"用户名\",\"inList\":true,\"inSearch\":true,\"inExport\":true,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"password\",\"label\":\"密码（bcrypt加密）\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"mobile\",\"label\":\"手机号\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"email\",\"label\":\"邮箱\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"nickname\",\"label\":\"昵称\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"avatar\",\"label\":\"头像\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"gender\",\"label\":\"性别\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"birthday\",\"label\":\"生日\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"money\",\"label\":\"余额\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"score\",\"label\":\"积分\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"level\",\"label\":\"会员等级\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"group_id\",\"label\":\"会员分组ID\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"status\",\"label\":\"状态\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"last_login_ip\",\"label\":\"最后登录IP\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"last_login_at\",\"label\":\"最后登录时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"login_count\",\"label\":\"登录次数\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"created_at\",\"label\":\"创建时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"updated_at\",\"label\":\"更新时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"deleted_at\",\"label\":\"删除时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"}]","relation-fields":"username","relation-search-fields":"username","relation-export-fields":"username"},"_tableProps":{"render":"none","operator":"eq","sortable":"false"}}', 'remoteSelect', '', 2);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (493, 37, 'username', 'Username', 'username', 'varchar(32)', 'string', 'string', '用户名', 0, 1, 1, 1, 0, 'like', 'string', '', 'input', '', 3);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (494, 37, 'ip', 'Ip', 'ip', 'varchar(50)', 'string', 'string', '登录IP', 0, 1, 1, 1, 0, 'eq', 'string', '{"_formProps":{"validator":[],"validatorMsg":""},"_tableProps":{"render":"tag","operator":"like","sortable":"false"}}', 'input', '', 4);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (495, 37, 'user_agent', 'UserAgent', 'userAgent', 'varchar(512)', 'string', 'string', 'User-Agent', 0, 1, 1, 1, 0, 'eq', 'string', '', 'input', '', 5);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (496, 37, 'status', 'Status', 'status', 'tinyint(1)', 'int', 'number', '状态:0=成功,1=失败', 0, 1, 1, 1, 1, 'eq', 'radio', '{"_formProps":{"validator":[],"validatorMsg":"","dict-options":""},"_tableProps":{"render":"tag","operator":"eq","sortable":"false"}}', 'radio', '', 6);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (497, 37, 'message', 'Message', 'message', 'varchar(255)', 'string', 'string', '提示信息', 0, 1, 1, 1, 0, 'eq', 'string', '', 'input', '', 7);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (498, 37, 'created_at', 'CreatedAt', 'createdAt', 'datetime', '*gtime.Time', 'string', '登录时间', 0, 0, 1, 0, 0, 'between', 'datetime', '', 'datetime', '', 8);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (590, 50, 'id', 'Id', 'id', 'bigint(20) unsigned', 'uint64', 'number', '', 1, 0, 1, 0, 0, 'eq', 'pk', '', 'input', '', 1);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (591, 50, 'member_id', 'MemberId', 'memberId', 'bigint(20) unsigned', 'uint64', 'number', '会员ID', 0, 1, 1, 1, 0, 'eq', 'remoteSelect', '{"_formProps":{"validator":[],"validatorMsg":"","remote-table":"xy_member","remote-pk":"id","remote-field":"nickname","relation-fields-config":"[{\"field\":\"id\",\"label\":\"会员ID\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"username\",\"label\":\"用户名\",\"inList\":true,\"inSearch\":true,\"inExport\":true,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"password\",\"label\":\"密码（bcrypt加密）\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"mobile\",\"label\":\"手机号\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"email\",\"label\":\"邮箱\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"nickname\",\"label\":\"昵称\",\"inList\":true,\"inSearch\":true,\"inExport\":true,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"avatar\",\"label\":\"头像\",\"inList\":true,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"tag\"},{\"field\":\"gender\",\"label\":\"性别\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"birthday\",\"label\":\"生日\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"money\",\"label\":\"余额\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"score\",\"label\":\"积分\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"level\",\"label\":\"会员等级\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"group_id\",\"label\":\"会员分组ID\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"status\",\"label\":\"状态\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"last_login_ip\",\"label\":\"最后登录IP\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"last_login_at\",\"label\":\"最后登录时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"login_count\",\"label\":\"登录次数\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"created_at\",\"label\":\"创建时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"updated_at\",\"label\":\"更新时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"deleted_at\",\"label\":\"删除时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"}]","relation-fields":"username,nickname,avatar","relation-search-fields":"username,nickname","relation-export-fields":"username,nickname"},"_tableProps":{"render":"none","operator":"eq","sortable":"false"}}', 'remoteSelect', '', 2);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (592, 50, 'money', 'Money', 'money', 'int(11)', 'int', 'number', '变动金额', 0, 1, 1, 1, 0, 'eq', 'number', '{"_formProps":{"validator":[],"validatorMsg":"","step":1},"_tableProps":{"render":"none","operator":"eq","sortable":"custom"}}', 'inputNumber', '', 3);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (593, 50, 'before', 'Before', 'before', 'int(11)', 'int', 'number', '变动前余额（分）', 0, 1, 1, 1, 0, 'eq', 'number', '', 'inputNumber', '', 4);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (594, 50, 'after', 'After', 'after', 'int(11)', 'int', 'number', '变动后余额（分）', 0, 1, 1, 1, 0, 'eq', 'number', '', 'inputNumber', '', 5);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (595, 50, 'memo', 'Memo', 'memo', 'varchar(255)', 'string', 'string', '变动说明', 0, 1, 1, 1, 0, 'eq', 'string', '', 'input', '', 6);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (596, 50, 'created_at', 'CreatedAt', 'createdAt', 'datetime', '*gtime.Time', 'string', '创建时间', 0, 0, 1, 0, 0, 'between', 'datetime', '', 'datetime', '', 7);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (604, 51, 'id', 'Id', 'id', 'bigint(20) unsigned', 'uint64', 'number', '', 1, 0, 1, 0, 0, 'eq', 'pk', '{"_formProps":{},"_tableProps":{}}', 'input', '', 1);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (605, 51, 'member_id', 'MemberId', 'memberId', 'bigint(20) unsigned', 'uint64', 'number', '会员ID', 0, 1, 1, 1, 0, 'eq', 'remoteSelect', '{"_formProps":{"validator":[],"validatorMsg":"","remote-table":"xy_member","remote-pk":"id","remote-field":"nickname","relation-fields-config":"[{\"field\":\"id\",\"label\":\"会员ID\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"username\",\"label\":\"用户名\",\"inList\":true,\"inSearch\":true,\"inExport\":true,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"password\",\"label\":\"密码（bcrypt加密）\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"mobile\",\"label\":\"手机号\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"email\",\"label\":\"邮箱\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"nickname\",\"label\":\"昵称\",\"inList\":true,\"inSearch\":true,\"inExport\":true,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"avatar\",\"label\":\"头像\",\"inList\":true,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"image\"},{\"field\":\"gender\",\"label\":\"性别\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"birthday\",\"label\":\"生日\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"money\",\"label\":\"余额\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"score\",\"label\":\"积分\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"level\",\"label\":\"会员等级\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"group_id\",\"label\":\"会员分组ID\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"status\",\"label\":\"状态\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"last_login_ip\",\"label\":\"最后登录IP\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"last_login_at\",\"label\":\"最后登录时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"login_count\",\"label\":\"登录次数\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"created_at\",\"label\":\"创建时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"updated_at\",\"label\":\"更新时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"deleted_at\",\"label\":\"删除时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"}]","relation-fields":"username,nickname,avatar","relation-search-fields":"username,nickname","relation-export-fields":"username,nickname"},"_tableProps":{"render":"none","operator":"eq","sortable":"false"}}', 'remoteSelect', '', 2);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (606, 51, 'money', 'Money', 'money', 'int(11)', 'int', 'number', '变动金额', 0, 1, 1, 1, 1, 'between', 'number', '{"_formProps":{"validator":[],"validatorMsg":"","step":1},"_tableProps":{"render":"none","operator":"eq","sortable":"custom"}}', 'inputNumber', '', 3);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (607, 51, 'before', 'Before', 'before', 'int(11)', 'int', 'number', '变动前余额（分）', 0, 1, 1, 1, 0, 'eq', 'number', '{"_formProps":{},"_tableProps":{}}', 'inputNumber', '', 4);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (608, 51, 'after', 'After', 'after', 'int(11)', 'int', 'number', '变动后余额（分）', 0, 1, 1, 1, 0, 'eq', 'number', '{"_formProps":{},"_tableProps":{}}', 'inputNumber', '', 5);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (609, 51, 'memo', 'Memo', 'memo', 'varchar(255)', 'string', 'string', '变动说明', 0, 1, 1, 1, 0, 'eq', 'string', '{"_formProps":{},"_tableProps":{}}', 'input', '', 6);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (610, 51, 'created_at', 'CreatedAt', 'createdAt', 'datetime', '*gtime.Time', 'string', '创建时间', 0, 0, 1, 0, 0, 'between', 'datetime', '{"_formProps":{},"_tableProps":{}}', 'datetime', '', 7);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (653, 52, 'id', 'Id', 'id', 'bigint(20) unsigned', 'uint64', 'number', '', 1, 0, 1, 0, 0, 'eq', 'pk', '{"_formProps":{},"_tableProps":{}}', 'input', '', 1);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (654, 52, 'member_id', 'MemberId', 'memberId', 'bigint(20) unsigned', 'uint64', 'number', '会员ID', 0, 1, 1, 1, 0, 'eq', 'remoteSelect', '{"_formProps":{"validator":[],"validatorMsg":"","remote-table":"xy_member","remote-pk":"id","remote-field":"nickname","relation-fields-config":"[{\"field\":\"id\",\"label\":\"会员ID\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"username\",\"label\":\"用户名\",\"inList\":true,\"inSearch\":true,\"inExport\":true,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"password\",\"label\":\"密码（bcrypt加密）\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"mobile\",\"label\":\"手机号\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"email\",\"label\":\"邮箱\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"nickname\",\"label\":\"昵称\",\"inList\":true,\"inSearch\":true,\"inExport\":true,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"avatar\",\"label\":\"头像\",\"inList\":true,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"image\"},{\"field\":\"gender\",\"label\":\"性别\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"birthday\",\"label\":\"生日\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"money\",\"label\":\"余额\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"score\",\"label\":\"积分\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"level\",\"label\":\"会员等级\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"group_id\",\"label\":\"会员分组ID\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"status\",\"label\":\"状态\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"last_login_ip\",\"label\":\"最后登录IP\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"last_login_at\",\"label\":\"最后登录时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"login_count\",\"label\":\"登录次数\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"created_at\",\"label\":\"创建时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"updated_at\",\"label\":\"更新时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"},{\"field\":\"deleted_at\",\"label\":\"删除时间\",\"inList\":false,\"inSearch\":false,\"inExport\":false,\"searchType\":\"like\",\"searchComponent\":\"input\",\"listRender\":\"text\"}]","relation-fields":"username,nickname,avatar","relation-search-fields":"username,nickname","relation-export-fields":"username,nickname"},"_tableProps":{"render":"none","operator":"eq","sortable":"false"}}', 'remoteSelect', '', 2);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (655, 52, 'score', 'Score', 'score', 'int(11)', 'int', 'number', '变动积分', 0, 1, 1, 1, 1, 'between', 'number', '{"_formProps":{"validator":[],"validatorMsg":"","step":1},"_tableProps":{"render":"none","operator":"eq","sortable":"custom"}}', 'inputNumber', '', 3);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (656, 52, 'before', 'Before', 'before', 'int(11)', 'int', 'number', '变动前积分', 0, 1, 1, 1, 0, 'eq', 'number', '{"_formProps":{},"_tableProps":{}}', 'inputNumber', '', 4);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (657, 52, 'after', 'After', 'after', 'int(11)', 'int', 'number', '变动后积分', 0, 1, 1, 1, 0, 'eq', 'number', '{"_formProps":{},"_tableProps":{}}', 'inputNumber', '', 5);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (658, 52, 'memo', 'Memo', 'memo', 'varchar(255)', 'string', 'string', '变动说明', 0, 1, 1, 1, 0, 'eq', 'string', '{"_formProps":{},"_tableProps":{}}', 'input', '', 6);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (659, 52, 'created_at', 'CreatedAt', 'createdAt', 'datetime', '*gtime.Time', 'string', '创建时间', 0, 0, 1, 0, 0, 'between', 'datetime', '{"_formProps":{},"_tableProps":{}}', 'datetime', '', 7);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (802, 67, 'id', 'Id', 'id', 'bigint(20) unsigned', 'uint64', 'number', '', 1, 0, 1, 0, 0, 'eq', 'pk', '', 'input', '', 1);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (803, 67, 'title', 'Title', 'title', 'varchar(255)', 'string', 'string', '通知标题', 0, 1, 1, 1, 1, 'like', 'string', '', 'input', '', 2);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (804, 67, 'content', 'Content', 'content', 'text', 'string', 'string', '通知内容', 0, 0, 0, 1, 0, 'eq', 'editor', '{"_formProps":{"validator":[],"validatorMsg":""},"_tableProps":{"render":"none","operator":"false","sortable":"false"}}', 'richEditor', '', 3);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (805, 67, 'type', 'Type', 'type', 'varchar(20)', 'string', 'string', '通知类型', 0, 1, 1, 1, 1, 'eq', 'select', '{"_formProps":{"validator":[],"validatorMsg":"","dict-options":"system=系统通知,announce=公告,feature=功能更新,maintain=维护通知"},"_tableProps":{"render":"tag","operator":"eq","sortable":"false"}}', 'select', '', 4);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (806, 67, 'target', 'Target', 'target', 'varchar(20)', 'string', 'string', '目标', 0, 1, 1, 1, 0, 'eq', 'radio', '{"_formProps":{"validator":[],"validatorMsg":"","dict-options":"all=全部会员,group=指定分组"},"_tableProps":{"render":"tag","operator":"eq","sortable":"false"}}', 'radio', '', 5);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (807, 67, 'target_id', 'TargetId', 'targetId', 'bigint(20) unsigned', 'uint64', 'number', '目标分组ID', 0, 1, 1, 1, 0, 'eq', 'remoteSelect', '{"_formProps":{"validator":[],"validatorMsg":"","remote-table":"xy_member_group","remote-pk":"id","remote-field":"name","relation-fields-config":"[]","relation-fields":"","relation-search-fields":"","relation-export-fields":""},"_tableProps":{"render":"none","operator":"eq","sortable":"false"}}', 'remoteSelect', '', 6);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (808, 67, 'sender', 'Sender', 'sender', 'varchar(50)', 'string', 'string', '发送者', 0, 1, 1, 1, 0, 'eq', 'string', '', 'input', '', 7);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (809, 67, 'status', 'Status', 'status', 'tinyint(1)', 'int', 'number', '状态', 0, 1, 1, 1, 1, 'eq', 'radio', '{"_formProps":{"dict-options":"0=草稿,1=已发布","validator":[],"validatorMsg":""},"_tableProps":{"render":"tag","operator":"eq","sortable":"false"}}', 'radio', '', 8);
INSERT INTO public.xy_sys_gen_codes_column (id, gen_id, name, go_name, ts_name, db_type, go_type, ts_type, comment, is_pk, is_required, is_list, is_edit, is_query, query_type, design_type, extra, form_type, dict_type, sort) VALUES (810, 67, 'created_at', 'CreatedAt', 'createdAt', 'datetime', '*gtime.Time', 'string', '创建时间', 0, 0, 1, 0, 0, 'between', 'datetime', '', 'datetime', '', 9);


--
-- Data for Name: xy_test_category; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (1, 0, '电子产品', 'ri:computer-line', '', 1, 1, '电子数码类', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (2, 0, '服装鞋帽', 'ri:t-shirt-line', '', 2, 1, '服饰类', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (3, 0, '食品饮料', 'ri:cup-line', '', 3, 1, '食品类', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (4, 1, '手机', 'ri:smartphone-line', '', 1, 1, '智能手机', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (5, 1, '电脑', 'ri:macbook-line', '', 2, 1, '笔记本/台式机', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (6, 1, '平板', 'ri:tablet-line', '', 3, 1, '平板电脑', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (7, 2, '男装', '', '', 1, 1, '', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (8, 2, '女装', '', '', 2, 1, '', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (9, 2, '鞋靴', '', '', 3, 0, '暂时下架', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (10, 4, 'iPhone', '', '', 1, 1, 'Apple手机', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (11, 4, 'Android', '', '', 2, 1, '安卓手机', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (12, 5, '游戏本', '', '', 1, 1, '', NULL, NULL);
INSERT INTO public.xy_test_category (id, parent_id, name, icon, image, sort, status, remark, created_at, updated_at) VALUES (13, 5, '轻薄本', '', '', 2, 1, '', NULL, NULL);


--
-- Data for Name: xy_test_code; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_test_code (id, name, member_id) VALUES (1, 'test', 1);


--
-- Data for Name: xy_test_codec; Type: TABLE DATA; Schema: xygonew; Owner: -
--



--
-- Data for Name: xy_test_order; Type: TABLE DATA; Schema: xygonew; Owner: -
--

INSERT INTO public.xy_test_order (id, member_id, apply_id, amount, status, memo, created_at, updated_at) VALUES (1, 1, 2, 199.90, 1, '测试订单A-已完成', NULL, NULL);
INSERT INTO public.xy_test_order (id, member_id, apply_id, amount, status, memo, created_at, updated_at) VALUES (2, 2, 1, 55.00, 0, '测试订单B-待处理', NULL, NULL);
INSERT INTO public.xy_test_order (id, member_id, apply_id, amount, status, memo, created_at, updated_at) VALUES (3, 1, 3, 320.50, 1, '测试订单C-已取消', NULL, NULL);
INSERT INTO public.xy_test_order (id, member_id, apply_id, amount, status, memo, created_at, updated_at) VALUES (4, 3, 2, 88.80, 1, '测试订单D-已完成', NULL, NULL);
INSERT INTO public.xy_test_order (id, member_id, apply_id, amount, status, memo, created_at, updated_at) VALUES (5, 2, 3, 1200.00, 0, '大额订单E-待处理', NULL, NULL);


--
-- Name: xy_admin_chat_message_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_chat_message_id_seq', 23, true);


--
-- Name: xy_admin_chat_session_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_chat_session_id_seq', 4, true);


--
-- Name: xy_admin_chat_session_member_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_chat_session_member_id_seq', 10, true);


--
-- Name: xy_admin_dept_closure_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_dept_closure_id_seq', 19, true);


--
-- Name: xy_admin_dept_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_dept_id_seq', 8, true);


--
-- Name: xy_admin_field_perm_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_field_perm_id_seq', 1, true);


--
-- Name: xy_admin_login_log_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_login_log_id_seq', 1, true);


--
-- Name: xy_admin_menu_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_menu_id_seq', 622, true);


--
-- Name: xy_admin_notice_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_notice_id_seq', 1, true);


--
-- Name: xy_admin_notice_read_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_notice_read_id_seq', 2, true);


--
-- Name: xy_admin_operation_log_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_operation_log_id_seq', 921, true);


--
-- Name: xy_admin_post_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_post_id_seq', 7, true);


--
-- Name: xy_admin_role_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_role_id_seq', 5, true);


--
-- Name: xy_admin_user_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_admin_user_id_seq', 4, true);


--
-- Name: xy_captcha_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_captcha_id_seq', 1, true);


--
-- Name: xy_demo_article_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_demo_article_id_seq', 3, true);


--
-- Name: xy_demo_category_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_demo_category_id_seq', 5, true);


--
-- Name: xy_member_checkin_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_member_checkin_id_seq', 3, true);


--
-- Name: xy_member_group_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_member_group_id_seq', 2, true);


--
-- Name: xy_member_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_member_id_seq', 1, true);


--
-- Name: xy_member_login_log_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_member_login_log_id_seq', 19, true);


--
-- Name: xy_member_menu_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_member_menu_id_seq', 11, true);


--
-- Name: xy_member_money_log_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_member_money_log_id_seq', 1, true);


--
-- Name: xy_member_notice_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_member_notice_id_seq', 3, true);


--
-- Name: xy_member_notice_read_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_member_notice_read_id_seq', 3, true);


--
-- Name: xy_member_score_log_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_member_score_log_id_seq', 3, true);


--
-- Name: xy_sys_attachment_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_sys_attachment_id_seq', 8, true);


--
-- Name: xy_sys_config_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_sys_config_id_seq', 57, true);


--
-- Name: xy_sys_cron_group_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_sys_cron_group_id_seq', 2, true);


--
-- Name: xy_sys_cron_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_sys_cron_id_seq', 2, true);


--
-- Name: xy_sys_cron_log_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_sys_cron_log_id_seq', 31, true);


--
-- Name: xy_sys_gen_codes_column_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_sys_gen_codes_column_id_seq', 810, true);


--
-- Name: xy_sys_gen_codes_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_sys_gen_codes_id_seq', 67, true);


--
-- Name: xy_test_category_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_test_category_id_seq', 13, true);


--
-- Name: xy_test_code_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_test_code_id_seq', 1, true);


--
-- Name: xy_test_codec_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_test_codec_id_seq', 1, true);


--
-- Name: xy_test_order_id_seq; Type: SEQUENCE SET; Schema: xygonew; Owner: -
--

SELECT pg_catalog.setval('public.xy_test_order_id_seq', 5, true);


--
-- Name: xy_admin_chat_message idx_17075_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_chat_message
    ADD CONSTRAINT idx_17075_primary PRIMARY KEY (id);


--
-- Name: xy_admin_chat_session idx_17086_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_chat_session
    ADD CONSTRAINT idx_17086_primary PRIMARY KEY (id);


--
-- Name: xy_admin_chat_session_member idx_17102_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_chat_session_member
    ADD CONSTRAINT idx_17102_primary PRIMARY KEY (id);


--
-- Name: xy_admin_dept idx_17115_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_dept
    ADD CONSTRAINT idx_17115_primary PRIMARY KEY (id);


--
-- Name: xy_admin_dept_closure idx_17126_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_dept_closure
    ADD CONSTRAINT idx_17126_primary PRIMARY KEY (id);


--
-- Name: xy_admin_field_perm idx_17132_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_field_perm
    ADD CONSTRAINT idx_17132_primary PRIMARY KEY (id);


--
-- Name: xy_admin_login_log idx_17142_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_login_log
    ADD CONSTRAINT idx_17142_primary PRIMARY KEY (id);


--
-- Name: xy_admin_menu idx_17158_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_menu
    ADD CONSTRAINT idx_17158_primary PRIMARY KEY (id);


--
-- Name: xy_admin_notice idx_17188_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_notice
    ADD CONSTRAINT idx_17188_primary PRIMARY KEY (id);


--
-- Name: xy_admin_notice_read idx_17206_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_notice_read
    ADD CONSTRAINT idx_17206_primary PRIMARY KEY (id);


--
-- Name: xy_admin_operation_log idx_17212_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_operation_log
    ADD CONSTRAINT idx_17212_primary PRIMARY KEY (id);


--
-- Name: xy_admin_post idx_17231_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_post
    ADD CONSTRAINT idx_17231_primary PRIMARY KEY (id);


--
-- Name: xy_admin_role idx_17245_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_role
    ADD CONSTRAINT idx_17245_primary PRIMARY KEY (id);


--
-- Name: xy_admin_role_menu idx_17260_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_role_menu
    ADD CONSTRAINT idx_17260_primary PRIMARY KEY (role_id, menu_id);


--
-- Name: xy_admin_user idx_17264_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_user
    ADD CONSTRAINT idx_17264_primary PRIMARY KEY (id);


--
-- Name: xy_admin_user_post idx_17283_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_user_post
    ADD CONSTRAINT idx_17283_primary PRIMARY KEY (user_id, post_id);


--
-- Name: xy_admin_user_role idx_17286_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_admin_user_role
    ADD CONSTRAINT idx_17286_primary PRIMARY KEY (user_id, role_id);


--
-- Name: xy_captcha idx_17290_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_captcha
    ADD CONSTRAINT idx_17290_primary PRIMARY KEY (id);


--
-- Name: xy_demo_article idx_17301_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_demo_article
    ADD CONSTRAINT idx_17301_primary PRIMARY KEY (id);


--
-- Name: xy_demo_category idx_17318_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_demo_category
    ADD CONSTRAINT idx_17318_primary PRIMARY KEY (id);


--
-- Name: xy_member idx_17331_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member
    ADD CONSTRAINT idx_17331_primary PRIMARY KEY (id);


--
-- Name: xy_member_checkin idx_17353_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_checkin
    ADD CONSTRAINT idx_17353_primary PRIMARY KEY (id);


--
-- Name: xy_member_group idx_17361_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_group
    ADD CONSTRAINT idx_17361_primary PRIMARY KEY (id);


--
-- Name: xy_member_login_log idx_17372_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_login_log
    ADD CONSTRAINT idx_17372_primary PRIMARY KEY (id);


--
-- Name: xy_member_menu idx_17385_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_menu
    ADD CONSTRAINT idx_17385_primary PRIMARY KEY (id);


--
-- Name: xy_member_money_log idx_17407_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_money_log
    ADD CONSTRAINT idx_17407_primary PRIMARY KEY (id);


--
-- Name: xy_member_notice idx_17417_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_notice
    ADD CONSTRAINT idx_17417_primary PRIMARY KEY (id);


--
-- Name: xy_member_notice_read idx_17430_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_notice_read
    ADD CONSTRAINT idx_17430_primary PRIMARY KEY (id);


--
-- Name: xy_member_score_log idx_17437_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_member_score_log
    ADD CONSTRAINT idx_17437_primary PRIMARY KEY (id);


--
-- Name: xy_sys_attachment idx_17447_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_attachment
    ADD CONSTRAINT idx_17447_primary PRIMARY KEY (id);


--
-- Name: xy_sys_config idx_17465_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_config
    ADD CONSTRAINT idx_17465_primary PRIMARY KEY (id);


--
-- Name: xy_sys_cron idx_17480_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_cron
    ADD CONSTRAINT idx_17480_primary PRIMARY KEY (id);


--
-- Name: xy_sys_cron_group idx_17499_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_cron_group
    ADD CONSTRAINT idx_17499_primary PRIMARY KEY (id);


--
-- Name: xy_sys_cron_log idx_17512_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_cron_log
    ADD CONSTRAINT idx_17512_primary PRIMARY KEY (id);


--
-- Name: xy_sys_gen_codes idx_17526_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_gen_codes
    ADD CONSTRAINT idx_17526_primary PRIMARY KEY (id);


--
-- Name: xy_sys_gen_codes_column idx_17541_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_sys_gen_codes_column
    ADD CONSTRAINT idx_17541_primary PRIMARY KEY (id);


--
-- Name: xy_test_category idx_17565_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_test_category
    ADD CONSTRAINT idx_17565_primary PRIMARY KEY (id);


--
-- Name: xy_test_code idx_17579_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_test_code
    ADD CONSTRAINT idx_17579_primary PRIMARY KEY (id);


--
-- Name: xy_test_codec idx_17586_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_test_codec
    ADD CONSTRAINT idx_17586_primary PRIMARY KEY (id);


--
-- Name: xy_test_order idx_17592_primary; Type: CONSTRAINT; Schema: xygonew; Owner: -
--

ALTER TABLE ONLY public.xy_test_order
    ADD CONSTRAINT idx_17592_primary PRIMARY KEY (id);


--
-- Name: idx_17075_idx_created_at; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17075_idx_created_at ON public.xy_admin_chat_message USING btree (created_at);


--
-- Name: idx_17075_idx_sender_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17075_idx_sender_id ON public.xy_admin_chat_message USING btree (sender_id);


--
-- Name: idx_17075_idx_session_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17075_idx_session_id ON public.xy_admin_chat_message USING btree (session_id);


--
-- Name: idx_17086_idx_creator_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17086_idx_creator_id ON public.xy_admin_chat_session USING btree (creator_id);


--
-- Name: idx_17086_idx_last_message_time; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17086_idx_last_message_time ON public.xy_admin_chat_session USING btree (last_message_time);


--
-- Name: idx_17102_idx_session_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17102_idx_session_id ON public.xy_admin_chat_session_member USING btree (session_id);


--
-- Name: idx_17102_idx_user_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17102_idx_user_id ON public.xy_admin_chat_session_member USING btree (user_id);


--
-- Name: idx_17102_uk_session_user; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17102_uk_session_user ON public.xy_admin_chat_session_member USING btree (session_id, user_id);


--
-- Name: idx_17126_idx_ancestor; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17126_idx_ancestor ON public.xy_admin_dept_closure USING btree (ancestor);


--
-- Name: idx_17126_idx_descendant; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17126_idx_descendant ON public.xy_admin_dept_closure USING btree (descendant);


--
-- Name: idx_17132_idx_resource; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17132_idx_resource ON public.xy_admin_field_perm USING btree (resource);


--
-- Name: idx_17132_idx_role_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17132_idx_role_id ON public.xy_admin_field_perm USING btree (role_id);


--
-- Name: idx_17132_idx_status; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17132_idx_status ON public.xy_admin_field_perm USING btree (status);


--
-- Name: idx_17132_uk_role_resource_field; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17132_uk_role_resource_field ON public.xy_admin_field_perm USING btree (role_id, resource, field_name);


--
-- Name: idx_17142_idx_created_at; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17142_idx_created_at ON public.xy_admin_login_log USING btree (created_at);


--
-- Name: idx_17142_idx_status; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17142_idx_status ON public.xy_admin_login_log USING btree (status);


--
-- Name: idx_17142_idx_user_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17142_idx_user_id ON public.xy_admin_login_log USING btree (user_id);


--
-- Name: idx_17142_idx_username; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17142_idx_username ON public.xy_admin_login_log USING btree (username);


--
-- Name: idx_17158_idx_parent_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17158_idx_parent_id ON public.xy_admin_menu USING btree (parent_id);


--
-- Name: idx_17158_idx_type; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17158_idx_type ON public.xy_admin_menu USING btree (type);


--
-- Name: idx_17188_idx_created; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17188_idx_created ON public.xy_admin_notice USING btree (created_at);


--
-- Name: idx_17188_idx_receiver; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17188_idx_receiver ON public.xy_admin_notice USING btree (receiver_id);


--
-- Name: idx_17188_idx_status; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17188_idx_status ON public.xy_admin_notice USING btree (status);


--
-- Name: idx_17188_idx_type; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17188_idx_type ON public.xy_admin_notice USING btree (type);


--
-- Name: idx_17206_idx_user; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17206_idx_user ON public.xy_admin_notice_read USING btree (user_id);


--
-- Name: idx_17206_uk_notice_user; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17206_uk_notice_user ON public.xy_admin_notice_read USING btree (notice_id, user_id);


--
-- Name: idx_17212_idx_created_at; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17212_idx_created_at ON public.xy_admin_operation_log USING btree (created_at);


--
-- Name: idx_17212_idx_module; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17212_idx_module ON public.xy_admin_operation_log USING btree (module);


--
-- Name: idx_17212_idx_status; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17212_idx_status ON public.xy_admin_operation_log USING btree (status);


--
-- Name: idx_17212_idx_user_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17212_idx_user_id ON public.xy_admin_operation_log USING btree (user_id);


--
-- Name: idx_17231_idx_created_by; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17231_idx_created_by ON public.xy_admin_post USING btree (created_by);


--
-- Name: idx_17231_idx_status; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17231_idx_status ON public.xy_admin_post USING btree (status);


--
-- Name: idx_17231_uk_code; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17231_uk_code ON public.xy_admin_post USING btree (code);


--
-- Name: idx_17245_uk_role_key; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17245_uk_role_key ON public.xy_admin_role USING btree (key);


--
-- Name: idx_17260_idx_menu_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17260_idx_menu_id ON public.xy_admin_role_menu USING btree (menu_id);


--
-- Name: idx_17264_idx_dept_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17264_idx_dept_id ON public.xy_admin_user USING btree (dept_id);


--
-- Name: idx_17264_idx_pid; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17264_idx_pid ON public.xy_admin_user USING btree (pid);


--
-- Name: idx_17264_uk_username; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17264_uk_username ON public.xy_admin_user USING btree (username);


--
-- Name: idx_17283_idx_post_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17283_idx_post_id ON public.xy_admin_user_post USING btree (post_id);


--
-- Name: idx_17283_idx_user_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17283_idx_user_id ON public.xy_admin_user_post USING btree (user_id);


--
-- Name: idx_17286_idx_role_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17286_idx_role_id ON public.xy_admin_user_role USING btree (role_id);


--
-- Name: idx_17290_uk_key; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17290_uk_key ON public.xy_captcha USING btree (key);


--
-- Name: idx_17301_idx_category; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17301_idx_category ON public.xy_demo_article USING btree (category_id);


--
-- Name: idx_17301_idx_status; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17301_idx_status ON public.xy_demo_article USING btree (status);


--
-- Name: idx_17318_idx_parent; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17318_idx_parent ON public.xy_demo_category USING btree (parent_id);


--
-- Name: idx_17331_idx_group_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17331_idx_group_id ON public.xy_member USING btree (group_id);


--
-- Name: idx_17331_idx_status; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17331_idx_status ON public.xy_member USING btree (status);


--
-- Name: idx_17331_uk_mobile; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17331_uk_mobile ON public.xy_member USING btree (mobile);


--
-- Name: idx_17331_uk_username; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17331_uk_username ON public.xy_member USING btree (username);


--
-- Name: idx_17353_idx_member_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17353_idx_member_id ON public.xy_member_checkin USING btree (member_id);


--
-- Name: idx_17353_uk_member_date; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17353_uk_member_date ON public.xy_member_checkin USING btree (member_id, checkin_date);


--
-- Name: idx_17372_idx_created_at; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17372_idx_created_at ON public.xy_member_login_log USING btree (created_at);


--
-- Name: idx_17372_idx_member_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17372_idx_member_id ON public.xy_member_login_log USING btree (member_id);


--
-- Name: idx_17385_idx_pid; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17385_idx_pid ON public.xy_member_menu USING btree (pid);


--
-- Name: idx_17407_idx_member_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17407_idx_member_id ON public.xy_member_money_log USING btree (member_id);


--
-- Name: idx_17417_idx_status_created; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17417_idx_status_created ON public.xy_member_notice USING btree (status, created_at);


--
-- Name: idx_17430_idx_member_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17430_idx_member_id ON public.xy_member_notice_read USING btree (member_id);


--
-- Name: idx_17430_uk_notice_member; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17430_uk_notice_member ON public.xy_member_notice_read USING btree (notice_id, member_id);


--
-- Name: idx_17437_idx_member_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17437_idx_member_id ON public.xy_member_score_log USING btree (member_id);


--
-- Name: idx_17465_idx_group_sort; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17465_idx_group_sort ON public.xy_sys_config USING btree ("group", sort);


--
-- Name: idx_17465_uk_config_key; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17465_uk_config_key ON public.xy_sys_config USING btree (key);


--
-- Name: idx_17480_idx_group_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17480_idx_group_id ON public.xy_sys_cron USING btree (group_id);


--
-- Name: idx_17480_idx_status; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17480_idx_status ON public.xy_sys_cron USING btree (status);


--
-- Name: idx_17480_uk_name; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17480_uk_name ON public.xy_sys_cron USING btree (name);


--
-- Name: idx_17512_idx_created_at; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17512_idx_created_at ON public.xy_sys_cron_log USING btree (created_at);


--
-- Name: idx_17512_idx_cron_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17512_idx_cron_id ON public.xy_sys_cron_log USING btree (cron_id);


--
-- Name: idx_17526_uk_table; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE UNIQUE INDEX idx_17526_uk_table ON public.xy_sys_gen_codes USING btree (db_name, table_name);


--
-- Name: idx_17541_idx_gen_id; Type: INDEX; Schema: xygonew; Owner: -
--

CREATE INDEX idx_17541_idx_gen_id ON public.xy_sys_gen_codes_column USING btree (gen_id);


-- ============================================================
-- CMS 文档模块
-- ============================================================

--
-- Name: xy_cms_doc_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.xy_cms_doc_category (
    id bigint NOT NULL,
    pid bigint DEFAULT 0 NOT NULL,
    title character varying(100) DEFAULT ''::character varying NOT NULL,
    icon character varying(100) DEFAULT ''::character varying NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    remark character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at bigint DEFAULT 0 NOT NULL,
    updated_at bigint DEFAULT 0 NOT NULL
);

COMMENT ON TABLE public.xy_cms_doc_category IS '文档分类表';
COMMENT ON COLUMN public.xy_cms_doc_category.id IS '分类ID';
COMMENT ON COLUMN public.xy_cms_doc_category.pid IS '父分类ID(0=顶级)';
COMMENT ON COLUMN public.xy_cms_doc_category.title IS '分类名称';
COMMENT ON COLUMN public.xy_cms_doc_category.icon IS '图标';
COMMENT ON COLUMN public.xy_cms_doc_category.sort IS '排序(越大越靠前)';
COMMENT ON COLUMN public.xy_cms_doc_category.status IS '状态:1=正常,2=禁用';
COMMENT ON COLUMN public.xy_cms_doc_category.remark IS '备注';
COMMENT ON COLUMN public.xy_cms_doc_category.created_at IS '创建时间';
COMMENT ON COLUMN public.xy_cms_doc_category.updated_at IS '更新时间';

--
-- Name: xy_cms_doc_category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.xy_cms_doc_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.xy_cms_doc_category_id_seq OWNED BY public.xy_cms_doc_category.id;

--
-- Name: xy_cms_doc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.xy_cms_doc (
    id bigint NOT NULL,
    category_id bigint DEFAULT 0 NOT NULL,
    title character varying(200) DEFAULT ''::character varying NOT NULL,
    slug character varying(200) DEFAULT ''::character varying NOT NULL,
    cover character varying(500) DEFAULT ''::character varying NOT NULL,
    summary character varying(500) DEFAULT ''::character varying NOT NULL,
    content text,
    author character varying(64) DEFAULT ''::character varying NOT NULL,
    views integer DEFAULT 0 NOT NULL,
    sort integer DEFAULT 0 NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    is_top smallint DEFAULT 0 NOT NULL,
    tags character varying(500) DEFAULT ''::character varying NOT NULL,
    created_by bigint DEFAULT 0 NOT NULL,
    updated_by bigint DEFAULT 0 NOT NULL,
    created_at bigint DEFAULT 0 NOT NULL,
    updated_at bigint DEFAULT 0 NOT NULL,
    deleted_at bigint DEFAULT 0 NOT NULL
);

COMMENT ON TABLE public.xy_cms_doc IS '文档内容表';
COMMENT ON COLUMN public.xy_cms_doc.id IS '文档ID';
COMMENT ON COLUMN public.xy_cms_doc.category_id IS '分类ID';
COMMENT ON COLUMN public.xy_cms_doc.title IS '文档标题';
COMMENT ON COLUMN public.xy_cms_doc.slug IS 'URL标识(唯一)';
COMMENT ON COLUMN public.xy_cms_doc.cover IS '封面图';
COMMENT ON COLUMN public.xy_cms_doc.summary IS '摘要';
COMMENT ON COLUMN public.xy_cms_doc.content IS '文档内容(Markdown)';
COMMENT ON COLUMN public.xy_cms_doc.author IS '作者';
COMMENT ON COLUMN public.xy_cms_doc.views IS '浏览量';
COMMENT ON COLUMN public.xy_cms_doc.sort IS '排序(越大越靠前)';
COMMENT ON COLUMN public.xy_cms_doc.status IS '状态:1=已发布,2=草稿,3=下架';
COMMENT ON COLUMN public.xy_cms_doc.is_top IS '是否置顶:0=否,1=是';
COMMENT ON COLUMN public.xy_cms_doc.tags IS '标签(JSON数组)';
COMMENT ON COLUMN public.xy_cms_doc.created_by IS '创建人ID';
COMMENT ON COLUMN public.xy_cms_doc.updated_by IS '更新人ID';
COMMENT ON COLUMN public.xy_cms_doc.created_at IS '创建时间';
COMMENT ON COLUMN public.xy_cms_doc.updated_at IS '更新时间';
COMMENT ON COLUMN public.xy_cms_doc.deleted_at IS '删除时间(软删除)';

--
-- Name: xy_cms_doc_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.xy_cms_doc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.xy_cms_doc_id_seq OWNED BY public.xy_cms_doc.id;

--
-- CMS defaults
--

ALTER TABLE ONLY public.xy_cms_doc_category ALTER COLUMN id SET DEFAULT nextval('public.xy_cms_doc_category_id_seq'::regclass);
ALTER TABLE ONLY public.xy_cms_doc ALTER COLUMN id SET DEFAULT nextval('public.xy_cms_doc_id_seq'::regclass);

--
-- CMS constraints
--

ALTER TABLE ONLY public.xy_cms_doc_category
    ADD CONSTRAINT xy_cms_doc_category_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.xy_cms_doc
    ADD CONSTRAINT xy_cms_doc_pkey PRIMARY KEY (id);

--
-- CMS indexes
--

CREATE INDEX idx_cms_doc_category_pid ON public.xy_cms_doc_category USING btree (pid);
CREATE INDEX idx_cms_doc_category_status_sort ON public.xy_cms_doc_category USING btree (status, sort);

CREATE UNIQUE INDEX uk_cms_doc_slug ON public.xy_cms_doc USING btree (slug);
CREATE INDEX idx_cms_doc_category_id ON public.xy_cms_doc USING btree (category_id);
CREATE INDEX idx_cms_doc_status ON public.xy_cms_doc USING btree (status);
CREATE INDEX idx_cms_doc_sort ON public.xy_cms_doc USING btree (sort);
CREATE INDEX idx_cms_doc_created_at ON public.xy_cms_doc USING btree (created_at);
CREATE INDEX idx_cms_doc_deleted_at ON public.xy_cms_doc USING btree (deleted_at);

--
-- CMS sequence values
--

SELECT pg_catalog.setval('public.xy_cms_doc_category_id_seq', 1, false);
SELECT pg_catalog.setval('public.xy_cms_doc_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

-- ============================================================
-- xy_migration: 数据库迁移版本记录
-- ============================================================
SET search_path = public;

CREATE TABLE IF NOT EXISTS xy_migration (
    id bigserial PRIMARY KEY,
    version varchar(32) NOT NULL UNIQUE,
    name varchar(128) NOT NULL DEFAULT '',
    executed_at bigint NOT NULL DEFAULT 0,
    checksum varchar(64) NOT NULL DEFAULT '',
    success smallint NOT NULL DEFAULT 1
);

-- ============================================================
-- xy_addon: 扩展安装记录
-- ============================================================
CREATE TABLE IF NOT EXISTS xy_addon (
    id bigserial PRIMARY KEY,
    name varchar(64) NOT NULL UNIQUE,
    version varchar(32) NOT NULL DEFAULT '',
    title varchar(128) NOT NULL DEFAULT '',
    status smallint NOT NULL DEFAULT 1,
    installed_at bigint NOT NULL DEFAULT 0,
    uninstalled_at bigint NOT NULL DEFAULT 0,
    file_list text
);

-- end of dump

