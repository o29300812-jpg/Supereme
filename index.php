<?php
session_start();
require_once 'config/Database.php';

$page = isset($_GET['page']) ? $_GET['page'] : 'home';
$allowed_pages = ['home', 'books', 'dictionary', 'cases', 'judgments', 'suggestions', 'login', 'signup', 'profile', 'logout'];
$page = in_array($page, $allowed_pages) ? $page : 'home';

// Admin check
$is_admin = isset($_SESSION['user_id']) && isset($_SESSION['is_admin']) && $_SESSION['is_admin'] == 1;
?>
<!DOCTYPE html>
<html lang="ur" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>سپریم - قانونی لائبریری | Supereme - Legal Library</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/animations.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Naskh+Arabic:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <?php include 'includes/navbar.php'; ?>

    <!-- Main Container -->
    <main class="main-container">
        <?php
        if ($page === 'login') {
            include 'pages/login.php';
        } elseif ($page === 'signup') {
            include 'pages/signup.php';
        } elseif ($page === 'logout') {
            include 'pages/logout.php';
        } elseif ($page === 'profile' && isset($_SESSION['user_id'])) {
            include 'pages/profile.php';
        } elseif ($page === 'home') {
            include 'pages/home.php';
        } elseif ($page === 'books') {
            include 'pages/books.php';
        } elseif ($page === 'dictionary') {
            include 'pages/dictionary.php';
        } elseif ($page === 'cases') {
            include 'pages/cases.php';
        } elseif ($page === 'judgments') {
            include 'pages/judgments.php';
        } elseif ($page === 'suggestions') {
            include 'pages/suggestions.php';
        } else {
            include 'pages/home.php';
        }
        ?>
    </main>

    <!-- Admin Panel (if admin) -->
    <?php if ($is_admin): ?>
        <div class="admin-fab" id="adminFab">
            <button class="fab-main" onclick="toggleAdminMenu()">
                <span class="admin-icon">⚙️</span>
            </button>
            <div class="fab-menu" id="fabMenu">
                <a href="admin/index.php" class="fab-item">Admin Panel</a>
                <a href="admin/manage-books.php" class="fab-item">Manage Books</a>
                <a href="admin/manage-dictionary.php" class="fab-item">Dictionary</a>
                <a href="admin/manage-cases.php" class="fab-item">Cases</a>
                <a href="admin/manage-judgments.php" class="fab-item">Judgments</a>
                <a href="admin/suggestions.php" class="fab-item">Suggestions</a>
            </div>
        </div>
    <?php endif; ?>

    <!-- Footer -->
    <?php include 'includes/footer.php'; ?>

    <script src="assets/js/main.js"></script>
    <script src="assets/js/animations.js"></script>
</body>
</html>