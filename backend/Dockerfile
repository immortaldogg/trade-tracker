# Use an official Python runtime as a parent image
FROM python:alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app/

# Install any needed dependencies
RUN pip install --no-cache-dir -r requirements.txt

RUN apk add --no-cache bash
RUN chmod +x ./entrypoint.sh

# Expose the port the app will run on
EXPOSE 8000

# Command to run the app with Uvicorn (FastAPI)
ENTRYPOINT ["bash", "entrypoint.sh"]