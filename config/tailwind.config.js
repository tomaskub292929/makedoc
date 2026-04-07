module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#1B3A6B',
          light: '#2A5298',
          dark: '#0F2341'
        },
        accent: {
          DEFAULT: '#E8A838',
          hover: '#D49530',
          light: '#FFF5E0'
        },
        bg: {
          white: '#FFFFFF',
          light: '#F5F7FA',
          cream: '#FDF8F0'
        },
        text: {
          dark: '#1A1A2E',
          body: '#4A4A68',
          muted: '#8A8AA3',
          white: '#FFFFFF'
        },
        border: {
          DEFAULT: '#E0E0E8',
          light: '#F0F0F5'
        },
        semantic: {
          success: '#27AE60',
          error: '#E74C3C'
        },
        faculty: {
          medical: '#2E7D32',
          physio: '#00897B',
          business: '#E8A838',
          engineering: '#1565C0',
          media: '#6A1B9A',
          arts: '#AD1457'
        }
      },
      fontFamily: {
        sans: ['Montserrat', '-apple-system', 'BlinkMacSystemFont', 'sans-serif'],
      },
      boxShadow: {
        sm: '0 1px 3px rgba(0, 0, 0, 0.06)',
        md: '0 4px 12px rgba(0, 0, 0, 0.08)',
        lg: '0 8px 30px rgba(0, 0, 0, 0.1)',
        card: '0 2px 8px rgba(0, 0, 0, 0.06)',
        'card-hover': '0 8px 30px rgba(0, 0, 0, 0.12)'
      },
      container: {
        center: true,
        padding: {
          DEFAULT: '24px',
          lg: '40px'
        },
        screens: {
          xl: '1200px'
        }
      }
    }
  },
  plugins: [],
}
