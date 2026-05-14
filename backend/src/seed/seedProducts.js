import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { getFirebase } from '../config/firebase.js';
import { COLLECTIONS } from '../utils/constants.js';
import { now } from '../services/firebaseService.js';

const __dirname = dirname(fileURLToPath(import.meta.url));
const rawProducts = JSON.parse(readFileSync(join(__dirname, '../data/products.seed.json'), 'utf8'));

function normalizeProduct(product, index) {
  const categoryId = product.category.toLowerCase().replace(/\s+/g, '-');
  return {
    productId: product.id,
    name: product.name,
    categoryId,
    categoryName: product.category,
    shortDescription: product.shortDescription,
    longDescription: product.longDescription,
    price: product.price,
    offerPrice: product.offerPrice,
    discountPercentage: product.discountPercentage,
    images: product.images,
    rating: product.rating,
    reviewCount: product.reviews?.length || 0,
    stock: product.stockCount,
    colors: product.colors,
    sizes: product.sizes,
    material: 'Full-grain genuine leather',
    brand: 'MOSPL',
    tags: [categoryId, 'premium-leather', 'onlinemadras'],
    isFeatured: index % 4 === 0,
    isBestSeller: index % 5 === 0,
    isNewArrival: index % 6 === 0,
    deliveryInfo: product.deliveryInfo,
    reviews: product.reviews,
    createdAt: now(),
    updatedAt: now(),
  };
}

export async function seedProducts() {
  const { db } = getFirebase();
  let batch = db.batch();
  let count = 0;
  for (const [index, product] of rawProducts.entries()) {
    const normalized = normalizeProduct(product, index);
    batch.set(db.collection(COLLECTIONS.PRODUCTS).doc(normalized.productId), normalized);
    count += 1;
    if (count % 400 === 0) {
      await batch.commit();
      batch = db.batch();
    }
  }
  await batch.commit();
  console.log(`Seeded ${count} MOSPL products.`);
}

if (import.meta.url === `file://${process.argv[1]}`) {
  seedProducts().catch((error) => { console.error(error); process.exit(1); });
}
