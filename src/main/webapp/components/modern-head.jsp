<%-- Modern head component with dark theme --%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#6366f1">

<!-- Fonts -->
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
        --card-bg: #1e293b;
        --light: #f8fafc;
        --gray: #64748b;
        --success: #10b981;
        --error: #ef4444;
        --warning: #f59e0b;
        --info: #06b6d4;
    }

    body {
        font-family: 'Inter', sans-serif;
        background: var(--dark);
        color: var(--light);
        min-height: 100vh;
    }

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
        opacity: 0.4;
        animation: float 20s infinite ease-in-out;
    }

    .orb-1 {
        width: 400px;
        height: 400px;
        background: var(--primary);
        top: -200px;
        right: -100px;
        animation-delay: 0s;
    }

    .orb-2 {
        width: 350px;
        height: 350px;
        background: var(--accent);
        bottom: -150px;
        left: -100px;
        animation-delay: -10s;
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

    .main-container {
        position: relative;
        z-index: 10;
        min-height: 100vh;
        padding: 80px 20px 20px;
        max-width: 1200px;
        margin: 0 auto;
    }

    .card {
        background: rgba(30, 41, 59, 0.8);
        backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 16px;
        padding: 24px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        margin-bottom: 24px;
    }

    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .btn-primary {
        background: linear-gradient(135deg, var(--primary), var(--secondary));
        color: white;
        box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
    }

    .btn-success {
        background: linear-gradient(135deg, var(--success), #059669);
        color: white;
        box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
    }

    .btn-success:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
    }

    .btn-danger {
        background: linear-gradient(135deg, var(--error), #dc2626);
        color: white;
        box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
    }

    .btn-danger:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(239, 68, 68, 0.4);
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 500;
        margin-bottom: 8px;
        color: var(--light);
    }

    .form-input {
        width: 100%;
        background: rgba(15, 23, 42, 0.6);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        color: var(--light);
        padding: 12px 16px;
        transition: all 0.3s;
        outline: none;
    }

    .form-input:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        background: rgba(15, 23, 42, 0.8);
    }

    .form-input::placeholder {
        color: var(--gray);
    }

    .alert {
        padding: 16px;
        border-radius: 12px;
        margin-bottom: 24px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .alert-success {
        background: rgba(16, 185, 129, 0.1);
        border: 1px solid rgba(16, 185, 129, 0.3);
        color: #6ee7b7;
    }

    .alert-error {
        background: rgba(239, 68, 68, 0.1);
        border: 1px solid rgba(239, 68, 68, 0.3);
        color: #fca5a5;
    }

    .table {
        width: 100%;
        border-collapse: collapse;
    }

    .table th, .table td {
        padding: 12px 16px;
        text-align: left;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .table th {
        background: rgba(15, 23, 42, 0.5);
        font-weight: 600;
        color: var(--light);
    }

    .table tr:hover {
        background: rgba(255, 255, 255, 0.05);
    }

    .badge {
        display: inline-flex;
        align-items: center;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
    }

    .badge-success {
        background: rgba(16, 185, 129, 0.2);
        color: #6ee7b7;
    }

    .badge-danger {
        background: rgba(239, 68, 68, 0.2);
        color: #fca5a5;
    }

    .badge-info {
        background: rgba(6, 182, 212, 0.2);
        color: #67e8f9;
    }

    .grid {
        display: grid;
        gap: 24px;
    }

    .grid-cols-1 { grid-template-columns: repeat(1, 1fr); }
    .grid-cols-2 { grid-template-columns: repeat(2, 1fr); }
    .grid-cols-3 { grid-template-columns: repeat(3, 1fr); }

    .stat-card {
        background: linear-gradient(135deg, var(--primary), var(--secondary));
        border-radius: 16px;
        padding: 24px;
        color: white;
        box-shadow: 0 10px 40px rgba(99, 102, 241, 0.3);
    }

    .stat-card.success {
        background: linear-gradient(135deg, var(--success), #059669);
        box-shadow: 0 10px 40px rgba(16, 185, 129, 0.3);
    }

    .stat-card.danger {
        background: linear-gradient(135deg, var(--error), #dc2626);
        box-shadow: 0 10px 40px rgba(239, 68, 68, 0.3);
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

    .animate-fade-in {
        animation: fadeInUp 0.6s ease-out;
    }

    @media (max-width: 768px) {
        .grid-cols-2, .grid-cols-3 {
            grid-template-columns: 1fr;
        }
        .main-container {
            padding: 60px 16px 16px;
        }
    }
</style>