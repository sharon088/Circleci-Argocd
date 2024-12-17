FROM python:3-slim AS build

ENV BG_COLOR "#f0f0f0"

# Install dependencies
COPY requirments.txt .
RUN pip install --upgrade pip --no-cache-dir
RUN pip install -r requirments.txt --no-cache-dir

# Copy the app code
COPY . .

# Create log directories
RUN mkdir -p /var/log/flask /var/log/gunicorn

# Set permissions (if necessary)
RUN chmod -R 755 /var/log/flask /var/log/gunicorn

# Expose the port for Gunicorn
EXPOSE 8000

# Start Gunicorn and configure logging
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "wsgi:app", "--access-logfile", "/var/log/gunicorn/access.log", "--error-logfile", "/var/log/gunicorn/error.log"]
