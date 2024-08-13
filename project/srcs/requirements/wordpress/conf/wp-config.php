<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to wp-config.php
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 * 
 * @link https://www.hostinger.com/tutorials/wp-config-php
 *
 * @package WordPress
 */

// Set default server variables if they are not set
if (!isset($_SERVER['HTTP_HOST'])) {
    $_SERVER['HTTP_HOST'] = getenv('NGINX_HOST_DOMAIN') ?: 'localhost';
}

if (!isset($_SERVER['HTTPS'])) {
    $_SERVER['HTTPS'] = 'on';
}

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', getenv('DB_NAME' ));
define( 'DB_USER', getenv('MYSQL_USER' ));
define( 'DB_PASSWORD', getenv('DB_PASSWORD' ));
#define('DB_HOST', 'mariadb:3306');
define( 'DB_HOST', getenv('DB_HOST' ));

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
##define( 'AUTH_KEY',         getenv('AUTH_KEY_HERE' ));
##define( 'SECURE_AUTH_KEY',  getenv('SECURE_AUTH_KEY_HERE' ));
##define( 'LOGGED_IN_KEY',    getenv('LOGGED_IN_KEY_HERE' ));
##define( 'NONCE_KEY',        getenv('NONCE_KEY_HERE' ));
##define( 'AUTH_SALT',        getenv('AUTH_SALT_HERE' ));
##define( 'SECURE_AUTH_SALT', getenv('SECURE_AUTH_SALT_HERE' ));
##define( 'LOGGED_IN_SALT',   getenv('LOGGED_IN_SALT_HERE' ));
##define( 'NONCE_SALT',       getenv('NONCE_SALT_HERE' ));

define( 'AUTH_KEY',  '}zeH.o>I|bIQ4s:hevQ4V39Y)ea16<+Vj%Qa1Z9Lv2eNhc+x>/Hq7BE8J^7s=ZBd');       
define( 'SECURE_AUTH_KEY', 'ixhrg7Q>]N1RxC^iqK,;i0-[F}[%Res`3^fuAWxbA[s=@q(f(K4X5Xu]L5s!ClC~');
define( 'LOGGED_IN_KEY',  'V{-DK-7dG_PqLFPB|ENrZDoDYWSfe-e29%L|<)<0+<ulsfPT]Q>Oj8fb-_3[CTRO');
define( 'NONCE_KEY', '3}rN+hLC`riD1Lx6r7JPK_yJh6+:*ck4^r!c,&a5NL}oo g1=v{`LUc1-&JZ:<+u');
define( 'AUTH_SALT', 'xB*jrQP>b08E8+Bp+~k|##-x#u1.+B4hBG]H`q:6v%H~7QtU:|m:6GF^83A8a|aQ' );
define( 'SECURE_AUTH_SALT', 'x|SxF({H-uPI[1q%-|X,8}x`&~*|2*xS6)L0#9r+7T5rmZnp?Xqod4I9UP]%(C*j' );
define( 'LOGGED_IN_SALT', '`W8^Y*zaBy2VS1T2vQT-njOqfem,z(ZWKextSMF3{_8HYy`EYV(FINv(qM,JxI-Q' );
define( 'NONCE_SALT', 'pBk%cBs[Z+%1OCMtgC! b|I-jc@v=W;$$upOeMhXQ.hY(Pk!BhF|]>gh|{1uCt4|0');

## ## Generated from https://api.wordpress.org/secret-key/1.1/salt/ 


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
 $table_prefix = 'wp_inception_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', true );

// Enable Debug logging to the /wp-content/debug.log file
define( 'WP_DEBUG_LOG', true );

/* Add any custom values between this line and the stop editing line. */

define('FORCE_SSL_ADMIN', true);

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
