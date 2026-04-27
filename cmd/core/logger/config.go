package core_logger

import "github.com/kelseyhightower/envconfig"

type Config struct {
	Level  string `envconfig:"LEVEL" required:"true"`
	Folder string `envconfig:"FOLDER" required:"true"`
}

func NewConfig() (*Config, error) {

	var cfg Config

	if err := envconfig.Process("LOGGER", &cfg); err != nil {
		return nil, err
	}

	return &cfg, nil
}

func NewConfigMust() *Config {
	cfg, err := NewConfig()

	if err != nil {
		panic(err)
	}

	return cfg
}
