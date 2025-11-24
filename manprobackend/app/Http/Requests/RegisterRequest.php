<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class RegisterRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'nama_lengkap' => 'required|string|min:3|max:255',
            'username' => 'required|string|min:3|max:255|unique:users',
            'email' => 'required|string|email|max:255|unique:users',
            'kota_asal' => 'required|string|min:3|max:255',
            'no_telpon' => [
                'required',
                'string',
                'min:2',
                'max:15',
                'regex:/^[0-9]+$/',
                'regex:/^08[0-9]{1,13}$/'  // Format nomor Indonesia dimulai dengan 08
            ],
            'password' => 'required|string|min:3',
        ];
    }

    /**
     * Get the error messages for the defined validation rules.
     *
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'no_telpon.regex' => 'Nomor telepon harus dimulai dengan 08 dan hanya berisi angka',
            'no_telpon.min' => 'Nomor telepon minimal 2 digit',
            'no_telpon.max' => 'Nomor telepon maksimal 15 digit',
        ];
    }
}
