import { seedCategories } from '../seed/seedCategories.js';
import { seedProducts } from '../seed/seedProducts.js';
import { seedAdmin } from '../seed/seedAdmin.js';

async function seedAll() {
  await seedCategories();
  await seedProducts();
  await seedAdmin();
  console.log('Completed MOSPL Firestore seed.');
}

seedAll().catch((error) => { console.error(error); process.exit(1); });
