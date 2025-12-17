package models

import (
	"database/sql"
)

type Quote struct {
	ID     int    `json:"id"`
	Text   string `json:"text"`
	Author string `json:"author"`
}

type QuoteRepository struct {
	db *sql.DB
}

func NewQuoteRepository(db *sql.DB) *QuoteRepository {
	return &QuoteRepository{db: db}
}

func (r *QuoteRepository) GetRandomQuote() (*Quote, error) {
	query := `SELECT id, text, author FROM quotes ORDER BY RANDOM() LIMIT 1`

	var quote Quote
	err := r.db.QueryRow(query).Scan(&quote.ID, &quote.Text, &quote.Author)
	if err != nil {
		return nil, err
	}

	return &quote, nil
}

func (r *QuoteRepository) CreateQuote(text, author string) error {
	query := `INSERT INTO quotes (text, author) VALUES ($1, $2)`
	_, err := r.db.Exec(query, text, author)
	return err
}

func (r *QuoteRepository) GetCount() (int, error) {
	var count int
	err := r.db.QueryRow(`SELECT COUNT(*) FROM quotes`).Scan(&count)
	return count, err
}
