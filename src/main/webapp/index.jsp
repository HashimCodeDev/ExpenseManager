<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expense Manager - Smart Financial Control</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary: #6366f1;
            --secondary: #8b5cf6;
            --accent: #ec4899;
            --dark: #0f172a;
            --light: #f8fafc;
            --gray: #64748b;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--dark);
            color: var(--light);
            overflow-x: hidden;
        }

        /* Animated Background */
        .bg-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            background: linear-gradient(to bottom, #0f172a, #1e293b);
        }

        .orb {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            opacity: 0.5;
            animation: float 20s infinite ease-in-out;
        }

        .orb-1 {
            width: 500px;
            height: 500px;
            background: var(--primary);
            top: -250px;
            left: -100px;
            animation-delay: 0s;
        }

        .orb-2 {
            width: 400px;
            height: 400px;
            background: var(--secondary);
            bottom: -200px;
            right: -100px;
            animation-delay: -7s;
        }

        .orb-3 {
            width: 350px;
            height: 350px;
            background: var(--accent);
            top: 50%;
            right: 10%;
            animation-delay: -14s;
        }

        @keyframes float {
            0%, 100% {
                transform: translate(0, 0) scale(1);
            }
            33% {
                transform: translate(50px, -50px) scale(1.1);
            }
            66% {
                transform: translate(-30px, 30px) scale(0.9);
            }
        }

        /* Navigation */
        nav {
            position: relative;
            z-index: 100;
            padding: 24px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
        }

        .nav-container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 24px;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav-links {
            display: flex;
            gap: 40px;
            align-items: center;
        }

        .nav-links a {
            color: var(--light);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            position: relative;
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: -4px;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--primary);
            transition: width 0.3s;
        }

        .nav-links a:hover::after {
            width: 100%;
        }

        /* Hero Section */
        .hero {
            position: relative;
            z-index: 10;
            max-width: 1280px;
            margin: 0 auto;
            padding: 120px 32px;
            text-align: center;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 20px;
            background: rgba(99, 102, 241, 0.1);
            border: 1px solid rgba(99, 102, 241, 0.3);
            border-radius: 50px;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 32px;
            animation: fadeInDown 0.8s ease-out;
        }

        .badge-dot {
            width: 8px;
            height: 8px;
            background: var(--primary);
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                opacity: 1;
                transform: scale(1);
            }
            50% {
                opacity: 0.5;
                transform: scale(1.2);
            }
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        h1 {
            font-family: 'Space Grotesk', sans-serif;
            font-size: clamp(48px, 8vw, 80px);
            font-weight: 700;
            line-height: 1.1;
            margin-bottom: 24px;
            animation: fadeInUp 0.8s ease-out 0.2s backwards;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .gradient-text {
            background: linear-gradient(135deg, #fff 0%, var(--primary) 50%, var(--accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-description {
            font-size: clamp(18px, 2vw, 22px);
            color: var(--gray);
            max-width: 700px;
            margin: 0 auto 48px;
            line-height: 1.6;
            animation: fadeInUp 0.8s ease-out 0.4s backwards;
        }

        .cta-buttons {
            display: flex;
            gap: 16px;
            justify-content: center;
            flex-wrap: wrap;
            animation: fadeInUp 0.8s ease-out 0.6s backwards;
        }

        .btn {
            padding: 16px 32px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 16px;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            box-shadow: 0 10px 40px rgba(99, 102, 241, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 20px 60px rgba(99, 102, 241, 0.4);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.05);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.2);
        }

        /* Features Grid */
        .features {
            position: relative;
            z-index: 10;
            max-width: 1280px;
            margin: 80px auto;
            padding: 0 32px;
        }

        .section-title {
            text-align: center;
            margin-bottom: 64px;
        }

        .section-title h2 {
            font-family: 'Space Grotesk', sans-serif;
            font-size: clamp(36px, 5vw, 48px);
            margin-bottom: 16px;
        }

        .section-title p {
            color: var(--gray);
            font-size: 18px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
        }

        .feature-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 40px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            opacity: 0;
            transition: opacity 0.4s;
        }

        .feature-card:hover::before {
            opacity: 0.05;
        }

        .feature-card:hover {
            transform: translateY(-8px);
            border-color: rgba(99, 102, 241, 0.3);
            box-shadow: 0 20px 60px rgba(99, 102, 241, 0.2);
        }

        .feature-icon {
            font-size: 48px;
            margin-bottom: 24px;
            display: block;
            position: relative;
            z-index: 1;
        }

        .feature-card h3 {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 24px;
            margin-bottom: 12px;
            position: relative;
            z-index: 1;
        }

        .feature-card p {
            color: var(--gray);
            line-height: 1.6;
            position: relative;
            z-index: 1;
        }

        /* Stats Section */
        .stats {
            position: relative;
            z-index: 10;
            max-width: 1280px;
            margin: 120px auto;
            padding: 80px 32px;
            text-align: center;
            background: rgba(255, 255, 255, 0.02);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 48px;
            margin-top: 48px;
        }

        .stat-item h3 {
            font-family: 'Space Grotesk', sans-serif;
            font-size: 48px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }

        .stat-item p {
            color: var(--gray);
            font-size: 16px;
        }

        /* Footer */
        footer {
            position: relative;
            z-index: 10;
            text-align: center;
            padding: 40px 32px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--gray);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-links {
                gap: 20px;
            }

            .hero {
                padding: 80px 24px;
            }

            .cta-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: 1fr;
                gap: 32px;
            }
        }
    </style>
</head>
<body>
<div class="bg-animation">
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>
</div>

<nav>
    <div class="nav-container">
        <div class="logo">💰 ExpenseFlow</div>
        <div class="nav-links">
            <a href="#features">Features</a>
            <a href="login.jsp">Sign In</a>
        </div>
    </div>
</nav>

<section class="hero">
    <div class="hero-badge">
        <span class="badge-dot"></span>
        Smart Financial Management
    </div>
    <h1>
        Master Your Money<br>
        <span class="gradient-text">Control Your Future</span>
    </h1>
    <p class="hero-description">
        Experience effortless expense tracking with real-time insights, intelligent categorization, and powerful analytics. Take charge of your financial journey today.
    </p>
    <div class="cta-buttons">
        <a href="register.jsp" class="btn btn-primary">
            Get Started Free
            <span>→</span>
        </a>
        <a href="login.jsp" class="btn btn-secondary">
            Sign In
            <span>→</span>
        </a>
    </div>
</section>

<section class="features" id="features">
    <div class="section-title">
        <h2>Everything You Need</h2>
        <p>Powerful features to keep your finances on track</p>
    </div>
    <div class="features-grid">
        <div class="feature-card">
            <span class="feature-icon">🔐</span>
            <h3>Bank-Level Security</h3>
            <p>Your data is encrypted end-to-end with industry-leading security protocols.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">📊</span>
            <h3>Visual Analytics</h3>
            <p>Beautiful charts and graphs that make understanding your spending intuitive.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">⚡</span>
            <h3>Real-Time Sync</h3>
            <p>Access your financial data instantly across all your devices.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">🎯</span>
            <h3>Smart Categories</h3>
            <p>Automatically organize expenses with AI-powered categorization.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">💎</span>
            <h3>Budget Goals</h3>
            <p>Set targets and get notified when you're approaching your limits.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">📱</span>
            <h3>Mobile Ready</h3>
            <p>Gorgeous interface optimized for every screen size and device.</p>
        </div>
    </div>
</section>

<section class="stats">
    <h2>Trusted by Thousands</h2>
    <div class="stats-grid">
        <div class="stat-item">
            <h3>50K+</h3>
            <p>Active Users</p>
        </div>
        <div class="stat-item">
            <h3>$2M+</h3>
            <p>Tracked Monthly</p>
        </div>
        <div class="stat-item">
            <h3>99.9%</h3>
            <p>Uptime</p>
        </div>
        <div class="stat-item">
            <h3>4.9★</h3>
            <p>User Rating</p>
        </div>
    </div>
</section>

<footer>
    <p>&copy; 2025 ExpenseFlow. All rights reserved.</p>
</footer>
</body>
</html>