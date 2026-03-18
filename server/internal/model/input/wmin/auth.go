package wmin

// WxLoginInput 微信小游戏登录输入
type WxLoginInput struct {
	Code string `json:"code" v:"required#请提供微信登录code"`
}

// WxLoginOutput 微信小游戏登录输出
type WxLoginOutput struct {
	Token     string `json:"token"`
	ExpiresIn int64  `json:"expiresIn"`
	IsNew     bool   `json:"isNew"`
}

// OaAuthUrlInput 公众号授权URL生成输入
type OaAuthUrlInput struct {
	Redirect string `json:"redirect"`
}

// OaAuthUrlOutput 公众号授权URL生成输出
type OaAuthUrlOutput struct {
	Url string `json:"url"`
}

// OaCallbackInput 公众号授权回调输入
type OaCallbackInput struct {
	Code  string `json:"code"`
	State string `json:"state"`
}

// OaCallbackOutput 公众号授权回调输出
type OaCallbackOutput struct {
	Token     string `json:"token"`
	ExpiresIn int64  `json:"expiresIn"`
	IsNew     bool   `json:"isNew"`
}
