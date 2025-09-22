<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Expense Manager - Welcome</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/modern-style.css">
    <style>
        .hero-section {
            text-align: center;
            padding: 80px 0;
        }
        .hero-section h1 {
            background: linear-gradient(135deg, var(--primary), var(--info));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
            font-size: 3.5rem;
            margin-bottom: 24px;
            letter-spacing: -0.025em;
        }
        .hero-section p {
            font-size: 1.25rem;
            color: var(--gray);
            margin-bottom: 40px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }
        .hero-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
            margin-top: 80px;
        }
        .feature-card {
            backdrop-filter: blur(20px);
            background: rgba(255, 255, 255, 0.9);
            padding: 32px;
            border-radius: var(--border-radius);
            text-align: center;
            border: 1px solid var(--glass-border);
            box-shadow: var(--shadow-lg);
            transition: var(--transition);
        }
        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-xl);
        }
        .feature-icon {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        .feature-card h3 {
            color: var(--dark);
            margin-bottom: 16px;
            font-weight: 600;
        }
        .feature-card p {
            color: var(--gray);
            line-height: 1.6;
        }
        @media (max-width: 768px) {
            .hero-section h1 {
                font-size: 2.5rem;
            }
            .hero-buttons {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
    <div class="background-pattern"></div>
    <div class="container">
        <div class="hero-section">
            <div style="width: 120px; height: 120px; background: linear-gradient(135deg, var(--primary), var(--info)); border-radius: 50%; margin: 0 auto 32px; display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem; font-weight: bold;">💰</div>
            <h1>Expense Manager</h1>
            <p>Take control of your finances with our comprehensive expense and income tracking solution. Monitor your spending, track your earnings, and make informed financial decisions.</p>
            <div class="hero-buttons">
                <a href="login.jsp" class="btn btn-primary" style="padding: 16px 32px; font-size: 1.1rem;">Get Started</a>
                <a href="register.jsp" class="btn btn-success" style="padding: 16px 32px; font-size: 1.1rem;">Create Account</a>
            </div>
        </div>
        
        <div class="features">
            <div class="feature-card">
                <div class="feature-icon">🔐</div>
                <h3>Secure Authentication</h3>
                <p>Your financial data is protected with secure user authentication and password encryption.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">💳</div>
                <h3>Expense Tracking</h3>
                <p>Easily add, edit, and categorize your expenses to understand where your money goes.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">💰</div>
                <h3>Income Management</h3>
                <p>Track multiple income sources and monitor your earning patterns over time.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">📊</div>
                <h3>Detailed Reports</h3>
                <p>Generate comprehensive reports with filtering options and export capabilities.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">📱</div>
                <h3>Responsive Design</h3>
                <p>Access your financial data from any device with our mobile-friendly interface.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">📈</div>
                <h3>Real-time Dashboard</h3>
                <p>View your financial summary and recent transactions at a glance.</p>
            </div>
        </div>
    </div>
</body>
</html>