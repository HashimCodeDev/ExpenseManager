<%-- Modern head component with updated dependencies --%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#6366f1">

<!-- Tailwind CSS -->
<script src="https://cdn.tailwindcss.com"></script>
<script>
    tailwind.config = {
        theme: {
            extend: {
                colors: {
                    primary: '#6366f1',
                    secondary: '#64748b',
                    success: '#10b981',
                    danger: '#ef4444',
                    warning: '#f59e0b',
                    info: '#06b6d4'
                },
                fontFamily: {
                    sans: ['Inter', 'system-ui', 'sans-serif']
                }
            }
        }
    }
</script>

<!-- Alpine.js -->
<script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>

<!-- Inter Font -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<!-- Heroicons -->
<script src="https://unpkg.com/heroicons@2.0.18/24/outline/index.js" type="module"></script>

<!-- Custom CSS for animations and utilities -->
<link rel="stylesheet" href="css/modern-style.css">