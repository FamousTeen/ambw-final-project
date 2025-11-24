<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ProfileRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'nama_lengkap' => 'required|string|min:3|max:255',
            'username' => ['required', 'string', 'min:3', 'max:255', Rule::unique('users')->ignore($this->user()->id)],
            'email' => ['required', 'string', 'email', 'max:255', Rule::unique('users')->ignore($this->user()->id)],
            'kota_asal' => 'required|string|min:3|max:255',
            'no_telpon' => [
                'required',
                'string',
                'min:2',
                'max:15',
                'regex:/^[0-9]+$/',
                'regex:/^08[0-9]{1,13}$/'  // Format nomor Indonesia
            ],
        ];
    }

    public function messages(): array
    {
        return [
            'no_telpon.regex' => 'Nomor telepon harus dimulai dengan 08 dan hanya berisi angka',
            'no_telpon.min' => 'Nomor telepon minimal 2 digit',
            'no_telpon.max' => 'Nomor telepon maksimal 15 digit',
        ];
    }
}
