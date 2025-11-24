<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ShippingMethodRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $rules = [
            'name' => 'required|string|max:255'
        ];

        // Add unique rule except for updates
        if ($this->isMethod('post')) {
            $rules['name'] .= '|unique:shipping_methods';
        } else {
            $rules['name'] .= '|unique:shipping_methods,name,' . $this->route('type')->id;
        }

        return $rules;
    }
}
