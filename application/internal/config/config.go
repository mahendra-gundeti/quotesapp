package config

import (
	"fmt"
	"os"
	"strconv"
)

type Config struct {
	DBHost     string
	DBPort     int
	DBUser     string
	DBPassword string
	DBName     string
	DBSSLMode  string
	ServerPort string
}

func LoadConfig() (*Config, error) {
	config := &Config{}

	config.DBHost = getEnv("DB_HOST", "localhost")

	portStr := getEnv("DB_PORT", "5432")
	port, err := strconv.Atoi(portStr)
	if err != nil {
		return nil, err
	}
	config.DBPort = port

	config.DBUser = getEnv("DB_USER", "postgres")
	config.DBPassword = os.Getenv("DB_PASSWORD")
	config.DBName = getEnv("DB_NAME", "quotes_db")
	config.DBSSLMode = getEnv("DB_SSL_MODE", "require")
	config.ServerPort = getEnv("SERVER_PORT", "8080")

	if config.DBPassword == "" {
		return nil, fmt.Errorf("DB_PASSWORD required")
	}

	return config, nil
}

func (c *Config) GetDatabaseURL() string {
	return fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=%s",
		c.DBHost, c.DBPort, c.DBUser, c.DBPassword, c.DBName, c.DBSSLMode,
	)
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
