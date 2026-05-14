import { COLLECTIONS } from '../utils/constants.js';
import { success } from '../utils/responseHandler.js';
import { deleteDoc, listDocs, setDoc } from '../services/firebaseService.js';

export async function listCategories(req, res) {
  return success(res, { categories: await listDocs(COLLECTIONS.CATEGORIES, { limit: 100 }) });
}
export async function createCategory(req, res) {
  const categoryId = req.body.categoryId || req.body.name.toLowerCase().replace(/\s+/g, '-');
  return success(res, { category: await setDoc(COLLECTIONS.CATEGORIES, categoryId, { ...req.body, categoryId, active: req.body.active ?? true }, false) }, 'Category created', 201);
}
export async function updateCategory(req, res) {
  return success(res, { category: await setDoc(COLLECTIONS.CATEGORIES, req.params.id, req.body) }, 'Category updated');
}
export async function deleteCategory(req, res) {
  return success(res, await deleteDoc(COLLECTIONS.CATEGORIES, req.params.id), 'Category deleted');
}
