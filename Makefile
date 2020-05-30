start-backend:
	cd backend && \
	pipenv run python3 main.py

start-frontend:
	cd frontend && \
	elm reactor