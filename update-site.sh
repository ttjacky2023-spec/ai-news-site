#!/bin/bash
# AI News Site Auto-Update Script
# Run daily at 10:05 AM (after cron job generates content)

SITE_DIR="/root/.openclaw/workspace/ai-news-site"
DAILY_DIR="$SITE_DIR/daily"
WEEKLY_DIR="$SITE_DIR/weekly"
DATE=$(date +%Y-%m-%d)
WEEK=$(date +%Y-week%U)

echo "[$(date)] Starting AI News site update..."

# Create new daily page from template
mkdir -p "$DAILY_DIR"
cat > "$DAILY_DIR/$DATE.html" << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Daily Brief - DATE_PLACEHOLDER</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: #e8e8e8;
            line-height: 1.6;
            min-height: 100vh;
        }
        .container { max-width: 900px; margin: 0 auto; padding: 20px; }
        header {
            text-align: center;
            padding: 40px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 30px;
        }
        h1 {
            font-size: 2.5em;
            background: linear-gradient(90deg, #00d4ff, #7b2cbf);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        .subtitle { color: #888; font-size: 1.1em; }
        .nav {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin: 30px 0;
            flex-wrap: wrap;
        }
        .nav a {
            color: #00d4ff;
            text-decoration: none;
            padding: 10px 20px;
            border: 1px solid rgba(0,212,255,0.3);
            border-radius: 25px;
            transition: all 0.3s;
        }
        .nav a:hover, .nav a.active {
            background: rgba(0,212,255,0.1);
            border-color: #00d4ff;
        }
        .date-section {
            background: rgba(255,255,255,0.05);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            border-left: 4px solid #00d4ff;
        }
        .date-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .date-title { font-size: 1.5em; color: #00d4ff; }
        .date-badge {
            background: rgba(0,212,255,0.2);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
        }
        .news-item {
            padding: 15px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .news-item:last-child { border-bottom: none; }
        .news-category {
            display: inline-block;
            background: rgba(123,44,191,0.3);
            color: #b794f6;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 0.75em;
            margin-bottom: 8px;
        }
        .news-title { font-size: 1.1em; margin-bottom: 8px; color: #fff; }
        .news-content { color: #aaa; font-size: 0.95em; margin-bottom: 8px; }
        .news-source { color: #666; font-size: 0.85em; font-style: italic; }
        .footer {
            text-align: center;
            padding: 40px 0;
            color: #666;
            border-top: 1px solid rgba(255,255,255,0.1);
            margin-top: 40px;
        }
        .page-url {
            background: rgba(0,212,255,0.1);
            border: 1px dashed rgba(0,212,255,0.3);
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
            text-align: center;
            font-family: monospace;
            color: #00d4ff;
        }
        @media (max-width: 600px) {
            h1 { font-size: 1.8em; }
            .date-header { flex-direction: column; align-items: flex-start; gap: 10px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>🤖 AI Daily Brief</h1>
            <p class="subtitle">欧美AI资讯 · 每日更新 · 中文呈现</p>
        </header>
        
        <nav class="nav">
            <a href="/daily/DATE_PLACEHOLDER.html" class="active">每日资讯</a>
            <a href="/weekly/WEEK_PLACEHOLDER.html">本周热点</a>
            <a href="/">首页</a>
        </nav>

        <div class="page-url">
            📎 本页链接：https://ai-news-site-gamma.vercel.app/daily/DATE_PLACEHOLDER.html
        </div>

        <div class="date-section">
            <div class="date-header">
                <span class="date-title">📰 DATE_PLACEHOLDER</span>
                <span class="date-badge">内容加载中...</span>
            </div>
            
            <div class="news-item">
                <p style="color: #888;">今日资讯内容将由定时任务自动填充...</p>
            </div>
        </div>

        <footer class="footer">
            <p>AI Daily Brief · 美国区域高级助理出品</p>
            <p>数据来源：TechCrunch, The Verge, NYT, Reuters, Bloomberg等欧美媒体</p>
            <p>更新时间：DATE_PLACEHOLDER 10:00 CST</p>
        </footer>
    </div>
</body>
</html>
EOF

# Replace placeholders
sed -i "s/DATE_PLACEHOLDER/$DATE/g" "$DAILY_DIR/$DATE.html"
sed -i "s/WEEK_PLACEHOLDER/$WEEK/g" "$DAILY_DIR/$DATE.html"

echo "[$(date)] Created daily page: $DAILY_DIR/$DATE.html"

# Update index.html redirect to latest daily
sed -i "s|url=/daily/.*\.html|url=/daily/$DATE.html|g" "$SITE_DIR/index.html"
sed -i "s|href=\"/daily/.*\.html\"|href=\"/daily/$DATE.html\"|g" "$SITE_DIR/index.html"

echo "[$(date)] Updated index.html redirect to: $DATE"

# Check if today is Monday (1) for weekly update
if [ $(date +%u) -eq 1 ]; then
    echo "[$(date)] Today is Monday, creating weekly page..."
    mkdir -p "$WEEKLY_DIR"
    
    cat > "$WEEKLY_DIR/$WEEK.html" << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Weekly Top 10 - WEEK_PLACEHOLDER</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: #e8e8e8;
            line-height: 1.6;
            min-height: 100vh;
        }
        .container { max-width: 900px; margin: 0 auto; padding: 20px; }
        header {
            text-align: center;
            padding: 40px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 30px;
        }
        h1 {
            font-size: 2.5em;
            background: linear-gradient(90deg, #00d4ff, #7b2cbf);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }
        .subtitle { color: #888; font-size: 1.1em; }
        .nav {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin: 30px 0;
            flex-wrap: wrap;
        }
        .nav a {
            color: #00d4ff;
            text-decoration: none;
            padding: 10px 20px;
            border: 1px solid rgba(0,212,255,0.3);
            border-radius: 25px;
            transition: all 0.3s;
        }
        .nav a:hover, .nav a.active {
            background: rgba(0,212,255,0.1);
            border-color: #00d4ff;
        }
        .weekly-section {
            background: rgba(255,255,255,0.05);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            border-left: 4px solid #7b2cbf;
        }
        .weekly-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .weekly-title { font-size: 1.6em; color: #b794f6; }
        .weekly-date { color: #888; font-size: 0.95em; }
        .top-item {
            display: flex;
            gap: 15px;
            padding: 20px;
            margin-bottom: 15px;
            background: rgba(255,255,255,0.03);
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.05);
        }
        .top-rank {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #7b2cbf, #00d4ff);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.1em;
            flex-shrink: 0;
        }
        .top-content { flex: 1; }
        .top-title { font-size: 1.15em; color: #fff; margin-bottom: 8px; }
        .top-desc { color: #aaa; font-size: 0.95em; margin-bottom: 8px; }
        .top-source { color: #666; font-size: 0.85em; font-style: italic; }
        .top-impact {
            display: inline-block;
            background: rgba(0,212,255,0.15);
            color: #00d4ff;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 0.75em;
            margin-top: 8px;
        }
        .footer {
            text-align: center;
            padding: 40px 0;
            color: #666;
            border-top: 1px solid rgba(255,255,255,0.1);
            margin-top: 40px;
        }
        .page-url {
            background: rgba(123,44,191,0.1);
            border: 1px dashed rgba(123,44,191,0.3);
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
            text-align: center;
            font-family: monospace;
            color: #b794f6;
        }
        @media (max-width: 600px) {
            h1 { font-size: 1.8em; }
            .top-item { flex-direction: column; gap: 10px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>🔥 AI Weekly Top 10</h1>
            <p class="subtitle">欧美AI本周最热动态 · 每周一更新</p>
        </header>
        
        <nav class="nav">
            <a href="/daily/DATE_PLACEHOLDER.html">每日资讯</a>
            <a href="/weekly/WEEK_PLACEHOLDER.html" class="active">本周热点</a>
            <a href="/">首页</a>
        </nav>

        <div class="page-url">
            📎 本页链接：https://ai-news-site-gamma.vercel.app/weekly/WEEK_PLACEHOLDER.html
        </div>

        <div class="weekly-section">
            <div class="weekly-header">
                <span class="weekly-title">本周热点 TOP 10</span>
                <span class="weekly-date">WEEK_PLACEHOLDER</span>
            </div>
            
            <div class="top-item">
                <p style="color: #888;">本周热点内容将由定时任务自动填充...</p>
            </div>
        </div>

        <footer class="footer">
            <p>AI Weekly Top 10 · 美国区域高级助理出品</p>
            <p>数据来源：TechCrunch, The Verge, NYT, Reuters, Bloomberg等欧美媒体</p>
            <p>更新时间：DATE_PLACEHOLDER 10:00 CST</p>
        </footer>
    </div>
</body>
</html>
EOF

    sed -i "s/DATE_PLACEHOLDER/$DATE/g" "$WEEKLY_DIR/$WEEK.html"
    sed -i "s/WEEK_PLACEHOLDER/$WEEK/g" "$WEEKLY_DIR/$WEEK.html"
    echo "[$(date)] Created weekly page: $WEEKLY_DIR/$WEEK.html"
fi

# Cleanup old files (keep only last 30 days / 12 weeks)
echo "[$(date)] Cleaning up old files..."
find "$DAILY_DIR" -name "*.html" -type f -mtime +30 -delete
find "$WEEKLY_DIR" -name "*.html" -type f -mtime +84 -delete

# Also delete any daily files before 2026-02-24
find "$DAILY_DIR" -name "*.html" -type f | while read file; do
    filename=$(basename "$file" .html)
    if [[ "$filename" < "2026-02-24" ]]; then
        rm "$file"
        echo "[$(date)] Deleted old file: $file"
    fi
done

echo "[$(date)] Cleanup complete."
echo "[$(date)] Update finished!"
