<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Contact;
use App\Http\Requests\ContactRequest;

class ContactManagementController extends Controller
{
    public function index()
    {
        $contact = Contact::first();
        return view('admin.contact.index', compact('contact'));
    }

    public function update(ContactRequest $request)
    {
        try {
            $contact = Contact::firstOrCreate(
                [],
                [
                    'alamat' => '',
                    'email' => '',
                    'no_telp' => ''
                ]
            );
            
            $contact->update($request->validated());

            return back()->with('success', 'Contact information updated successfully');
        } catch (\Exception $e) {
            return back()->with('error', 'Error updating contact information: ' . $e->getMessage());
        }
    }
} 