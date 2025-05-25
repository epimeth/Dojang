import type { Student, StudentFilters } from '$lib/types/student';
import { EnsureFetchInitialized, type SvelteKitFetch, type FetchInitializable } from '$lib/utils/decorators';

@EnsureFetchInitialized
class StudentsService implements FetchInitializable {
  private _fetch!: SvelteKitFetch; // Will be initialized by init()
  private baseUrl = '/api/students';

  public init(fetchFn: SvelteKitFetch): void {
    this._fetch = fetchFn;
  }

  public _isFetchInitialized(): boolean {
    return !!this._fetch;
  }

  async getStudents(filters?: StudentFilters): Promise<Student[]> {
    const params = new URLSearchParams();
    if (filters?.search) params.set('search', filters.search);
    if (filters?.belt) params.set('belt', filters.belt.toString());

    try {
      const res = await this._fetch(`${this.baseUrl}?${params}`);
      if (!res.ok) {
        throw new Error('Failed to fetch students');
      }
      return await res.json();
    } catch (error) {
      console.error('Error fetching students:', error);
      throw error;
    }
  }

  async getStudent(id: string): Promise<Student> {
    try {
      const res = await this._fetch(`${this.baseUrl}/${id}`);
      if (!res.ok) {
        throw new Error('Failed to fetch student');
      }
      return await res.json();
    } catch (error) {
      console.error('Error fetching student:', error);
      throw error;
    }
  }

  async createStudent(student: Omit<Student, 'id'>): Promise<Student> {
    try {
      const res = await this._fetch(this.baseUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(student)
      });
      if (!res.ok) {
        throw new Error('Failed to create student');
      }
      return await res.json();
    } catch (error) {
      console.error('Error creating student:', error);
      throw error;
    }
  }

  async updateStudent(id: string, student: Partial<Student>): Promise<Student> {
    try {
      const res = await this._fetch(`${this.baseUrl}/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(student)
      });
      if (!res.ok) {
        throw new Error('Failed to update student');
      }
      return await res.json();
    } catch (error) {
      console.error('Error updating student:', error);
      throw error;
    }
  }

  async deleteStudent(id: string): Promise<void> {
    try {
      const res = await this._fetch(`${this.baseUrl}/${id}`, {
        method: 'DELETE'
      });
      if (!res.ok) {
        throw new Error('Failed to delete student');
      }
    } catch (error) {
      console.error('Error deleting student:', error);
      throw error;
    }
  }
}

export const studentsService = new StudentsService();