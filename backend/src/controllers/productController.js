import { COLLECTIONS } from '../utils/constants.js';
import { fail, success } from '../utils/responseHandler.js';
import { addDoc, deleteDoc, getDoc, listDocs, setDoc, uploadBuffer } from '../services/firebaseService.js';

export async function listProducts(req, res) {
  const filters = [];
  if (req.query.categoryId) filters.push(['categoryId', '==', req.query.categoryId]);
  const products = await listDocs(COLLECTIONS.PRODUCTS, { limit: req.query.limit || 100, where: filters });
  return success(res, { products });
}

export async function getProduct(req, res) {
  const product = await getDoc(COLLECTIONS.PRODUCTS, req.params.id);
  if (!product) throw fail('Product not found', 404);
  return success(res, { product });
}

export async function createProduct(req, res) {
  const productId = req.body.productId || `product-${Date.now()}`;
  const product = await setDoc(COLLECTIONS.PRODUCTS, productId, { ...req.body, productId, createdAt: new Date().toISOString() }, false);
  return success(res, { product }, 'Product created', 201);
}

export async function updateProduct(req, res) {
  const product = await setDoc(COLLECTIONS.PRODUCTS, req.params.id, req.body);
  return success(res, { product }, 'Product updated');
}

export async function deleteProduct(req, res) {
  return success(res, await deleteDoc(COLLECTIONS.PRODUCTS, req.params.id), 'Product deleted');
}

export async function productsByCategory(req, res) {
  const products = await listDocs(COLLECTIONS.PRODUCTS, { where: [['categoryId', '==', req.params.categoryId]], limit: 100 });
  return success(res, { products });
}

export async function searchProducts(req, res) {
  const q = String(req.query.q || '').toLowerCase();
  const products = (await listDocs(COLLECTIONS.PRODUCTS, { limit: 300 })).filter((p) => JSON.stringify(p).toLowerCase().includes(q));
  return success(res, { products });
}

export async function featuredProducts(req, res) {
  return success(res, { products: await listDocs(COLLECTIONS.PRODUCTS, { where: [['isFeatured', '==', true]], limit: 30 }) });
}

export async function bestsellerProducts(req, res) {
  return success(res, { products: await listDocs(COLLECTIONS.PRODUCTS, { where: [['isBestSeller', '==', true]], limit: 30 }) });
}

export async function uploadProductImage(req, res) {
  if (!req.file) throw fail('Image file is required', 422);
  const url = await uploadBuffer({ buffer: req.file.buffer, destination: `products/${Date.now()}-${req.file.originalname}`, contentType: req.file.mimetype });
  return success(res, { url }, 'Image uploaded');
}
