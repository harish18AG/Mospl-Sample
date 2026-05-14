import { getFirebase } from '../config/firebase.js';
import { COLLECTIONS } from '../utils/constants.js';
import { now } from '../services/firebaseService.js';

const categories = [
  'Leather Jackets', 'Leather Bags', 'Wallets', 'Belts', 'Shoes', 'Watches', 'Travel Bags', 'Office Bags', 'Accessories', 'Premium Collections',
];

export async function seedCategories() {
  const { db } = getFirebase();
  const batch = db.batch();
  categories.forEach((name, index) => {
    const categoryId = name.toLowerCase().replace(/\s+/g, '-');
    batch.set(db.collection(COLLECTIONS.CATEGORIES).doc(categoryId), {
      categoryId,
      name,
      description: `Premium ${name.toLowerCase()} curated by MOSPL.`,
      heroImage: `https://source.unsplash.com/900x700/?${encodeURIComponent(name)}`,
      sortOrder: index + 1,
      active: true,
      createdAt: now(),
      updatedAt: now(),
    });
  });
  await batch.commit();
  console.log(`Seeded ${categories.length} MOSPL categories.`);
}

if (import.meta.url === `file://${process.argv[1]}`) {
  seedCategories().catch((error) => { console.error(error); process.exit(1); });
}
