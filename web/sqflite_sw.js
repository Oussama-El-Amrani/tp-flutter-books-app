// sqflite service worker for web support
// This file is required for sqflite_common_ffi_web to work

importScripts('sqlite3.wasm.js');

// Initialize the SQLite worker
self.addEventListener('message', async (event) => {
  const { type, data } = event.data;
  
  try {
    switch (type) {
      case 'init':
        // Initialize SQLite
        await initSQLite();
        self.postMessage({ type: 'init', success: true });
        break;
      default:
        console.warn('Unknown message type:', type);
    }
  } catch (error) {
    console.error('SQLite worker error:', error);
    self.postMessage({ type: 'error', error: error.message });
  }
});

async function initSQLite() {
  // SQLite initialization logic will be handled by the library
  console.log('SQLite worker initialized');
}
