FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN python -c "from pathlib import Path; p=Path('/app/requirements.txt'); b=p.read_bytes(); \
enc='utf-16' if (b.startswith(b'\\xff\\xfe') or b.startswith(b'\\xfe\\xff') or b'\\x00' in b[:200]) else 'utf-8'; \
p.write_text(b.decode(enc), encoding='utf-8', newline='\\n')" \
 && pip install --no-cache-dir -r /app/requirements.txt

COPY . /app

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
