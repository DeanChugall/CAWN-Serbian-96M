.PHONY: clean all allp format quality test deploy

#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -exec rm -rf {} +
	# delete all .pytest_cache
	find . -type d -name "*.pytest_cache" -exec rm -rf {} +
	# delete all .ruff_cache
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	rm -rf .pytest_cache
	rm -rf build
	rm -rf dist
	rm -rf .ipynb_checkpoints
	rm -rf .coverage*
	rm -rf node_modules

pre:
	pre-commit run --all-files

format:
	ruff format .
	ruff check --fix .

quality:
	ruff format --check .
	ruff check .

# POETRY
pinstall:
	poetry install
	poetry lock

# TEST
test:
	poetry run pytest

cov:
	poetry run pytest --cov=ai2you

# Git and Git Status
st:
	git status

all:
	git add .
	pre-commit run --all-files

# DEPLOYMENT
# DEPLOYMENT
deploy:
	@echo "🚀 Deploying AI Agent to Server (192.168.31.103 via Port 1110)..."
	rsync -avzP -e "ssh -p 1110" \
		--exclude=".venv" \
		--exclude=".git" \
		--exclude="__pycache__" \
		--exclude="*.pyc" \
		--exclude="*.session" \
		--exclude="experience_log.jsonl" \
		--exclude="GRAND_STRATEGY.md" \
		--exclude="CURRENT_SPRINT.md" \
		--exclude="system_prompt.txt" \
		--exclude="notify_datatab.py" \
		/home/datatab/Documents/development/ai2you/ \
		datatab@192.168.31.103:/home/datatab/Documents/Ai2You_Agents/v1
	@echo "✅ Deployment complete! Agent memory and Telegram session were preserved."
