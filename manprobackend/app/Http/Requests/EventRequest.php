<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class EventRequest extends FormRequest
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
            'title' => 'required|string|min:3|max:255',
            'content' => 'required|string|min:10',
            'image' => 'required|image|mimes:jpg,png,jpeg',
            'additional_images.*' => 'nullable|image|mimes:jpg,png,jpeg',
            'date' => 'required|date',
            'time' => 'required|date_format:H:i',
            'category_id' => 'required|exists:event_categories,id',
            'capacity' => 'nullable|integer|min:0'
        ];
    }
}
