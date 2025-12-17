package database

import (
	"database/sql"
	"log"

	"quotes-app/internal/config"
	"quotes-app/internal/models"

	_ "github.com/lib/pq"
)

func Connect(cfg *config.Config) (*sql.DB, error) {
	db, err := sql.Open("postgres", cfg.GetDatabaseURL())
	if err != nil {
		return nil, err
	}

	if err := db.Ping(); err != nil {
		return nil, err
	}

	return db, nil
}

func CreateTables(db *sql.DB) error {
	query := `
	CREATE TABLE IF NOT EXISTS quotes (
		id SERIAL PRIMARY KEY,
		text TEXT NOT NULL,
		author VARCHAR(255) NOT NULL
	);`

	_, err := db.Exec(query)
	return err
}

func SeedDatabase(db *sql.DB, repo *models.QuoteRepository) error {
	count, err := repo.GetCount()
	if err != nil {
		return err
	}

	if count > 0 {
		log.Printf("Database already has %d quotes", count)
		return nil
	}

	quotes := []struct {
		text   string
		author string
	}{
		{"The only way to do great work is to love what you do.", "Steve Jobs"},
		{"Innovation distinguishes between a leader and a follower.", "Steve Jobs"},
		{"Life is what happens to you while you're busy making other plans.", "John Lennon"},
		{"The future belongs to those who believe in the beauty of their dreams.", "Eleanor Roosevelt"},
		{"It is during our darkest moments that we must focus to see the light.", "Aristotle"},
		{"Do not go where the path may lead, go instead where there is no path and leave a trail.", "Ralph Waldo Emerson"},
		{"You will face many defeats in life, but never let yourself be defeated.", "Maya Angelou"},
		{"The only impossible journey is the one you never begin.", "Tony Robbins"},
		{"Your time is limited, so don't waste it living someone else's life.", "Steve Jobs"},
		{"Success is not final, failure is not fatal: it is the courage to continue that counts.", "Winston Churchill"},
	}

	for _, quote := range quotes {
		err := repo.CreateQuote(quote.text, quote.author)
		if err != nil {
			log.Printf("Error seeding quote: %v", err)
		}
	}

	finalCount, _ := repo.GetCount()
	log.Printf("Database seeded with %d quotes", finalCount)
	return nil
}
