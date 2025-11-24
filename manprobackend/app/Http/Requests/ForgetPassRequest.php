<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ForgetPassRequest extends FormRequest
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
            'email' => 'required|email|exists:users,email',
            'password' => 'required|min:3|confirmed',
            'password_confirmation' => 'required'
        ];
    }

    public function messages(): array
    {
        return [
            'email.exists' => 'Email tidak ditemukan',
            'password.confirmed' => 'Konfirmasi password tidak cocok'
        ];
    }
}
