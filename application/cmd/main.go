package main

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"quotes-app/internal/config"
	"quotes-app/internal/database"
	"quotes-app/internal/models"
)

type Server struct {
	repo *models.QuoteRepository
}

type HealthResponse struct {
	Status    string    `json:"status"`
	Timestamp time.Time `json:"timestamp"`
	Version   string    `json:"version"`
}

func (s *Server) livenessHandler(w http.ResponseWriter, r *http.Request) {
	response := HealthResponse{
		Status:    "alive",
		Timestamp: time.Now(),
		Version:   "1.0.0",
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}


func (s *Server) readinessHandler(w http.ResponseWriter, r *http.Request) {
	response := HealthResponse{
		Status:    "ready",
		Timestamp: time.Now(),
		Version:   "1.0.0",
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

func (s *Server) healthHandler(w http.ResponseWriter, r *http.Request) {
	response := HealthResponse{
		Status:    "healthy",
		Timestamp: time.Now(),
		Version:   "1.0.0",
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

func (s *Server) randomQuoteHandler(w http.ResponseWriter, r *http.Request) {
	quote, err := s.repo.GetRandomQuote()
	if err != nil {
		http.Error(w, "Error getting quote", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(quote)
}

func (s *Server) homeHandler(w http.ResponseWriter, r *http.Request) {
	html := `<!DOCTYPE html>
<html>
<head>
    <title>Random Quotes</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: white;
            margin: 0;
            padding: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }
        
        h1 {
            color: #333;
            margin-bottom: 30px;
            font-size: 2rem;
        }
        
        .get-quote-btn {
            background: #4CAF50;
            color: white;
            border: none;
            padding: 12px 24px;
            font-size: 16px;
            border-radius: 8px;
            cursor: pointer;
            margin-bottom: 30px;
        }
        
        .get-quote-btn:hover {
            background: #45a049;
        }
        
        .quote-tile {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 30px;
            max-width: 600px;
            width: 100%;
            min-height: 100px;
            height: 100px;
            box-shadow: 0 8px 8px rgba(0,0,0,0.1);
            position: relative;
        }
        
        .quote-text {
            font-size: 1.3rem;
            line-height: 1.6;
            color: #333;
            margin-bottom: 20px;
            font-style: italic;
        }
        
        .quote-author {
            color: #666;
            font-size: 1rem;
            font-weight: bold;
            position: absolute;
            bottom: 30px;
            right: 30px;
        }
    </style>
</head>
<body>
    <h1>Random Quote Generator</h1>
    <button class="get-quote-btn" onclick="getQuote()">Get Quote</button>
    <div id="quote-container"></div>
    
    <script>
        async function getQuote() {
            const response = await fetch('/api/quote');
            const quote = await response.json();
            document.getElementById('quote-container').innerHTML = 
                '<div class="quote-tile">' +
                '<div class="quote-text">"' + quote.text + '"</div>' +
                '<div class="quote-author">- ' + quote.author + '</div>' +
                '</div>';
        }
    </script>
</body>
</html>`

	w.Header().Set("Content-Type", "text/html")
	w.Write([]byte(html))
}

func main() {
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatal("Config error:", err)
	}

	db, err := database.Connect(cfg)
	if err != nil {
		log.Fatal("Database connection error:", err)
	}
	defer db.Close()

	if err := database.CreateTables(db); err != nil {
		log.Fatal("Create tables error:", err)
	}

	repo := models.NewQuoteRepository(db)

	if err := database.SeedDatabase(db, repo); err != nil {
		log.Fatal("Seed database error:", err)
	}

	server := &Server{
		repo: repo,
	}

	http.HandleFunc("/", server.homeHandler)
	http.HandleFunc("/api/quote", server.randomQuoteHandler)

	http.HandleFunc("/health", server.healthHandler)
	http.HandleFunc("/health/live", server.livenessHandler)
	http.HandleFunc("/health/ready", server.readinessHandler)

	log.Printf("Server starting on port %s", cfg.ServerPort)
	log.Fatal(http.ListenAndServe(":"+cfg.ServerPort, nil))
}
