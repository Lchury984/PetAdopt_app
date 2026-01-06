import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadopt_prueba2_app/features/pets/domain/entities/pet_entity.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_cubit.dart';
import 'package:petadopt_prueba2_app/core/constants/app_constants.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';
import 'package:petadopt_prueba2_app/core/widgets/app_back_button.dart';
import 'package:uuid/uuid.dart';

enum PetFormMode { create, edit }

class PetFormPage extends StatefulWidget {
  final PetFormMode mode;
  final String shelterId;
  final PetEntity? pet;

  const PetFormPage({
    Key? key,
    required this.mode,
    required this.shelterId,
    this.pet,
  }) : super(key: key);

  @override
  State<PetFormPage> createState() => _PetFormPageState();
}

class _PetFormPageState extends State<PetFormPage> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = AppConstants.petTypes.first;
  final List<Uint8List> _imageBytesList = [];
  final List<String> _imageNamesList = [];
  List<String> _existingImageUrls = [];
  bool _isSaving = false;
  static const int maxImages = 5;

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet!.name;
      _breedController.text = widget.pet!.breed;
      _ageController.text = widget.pet!.age.toString();
      _descriptionController.text = widget.pet!.description;
      _selectedType = widget.pet!.type;
      _existingImageUrls = List.from(widget.pet!.imageUrls);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_isSaving) return;
    final name = _nameController.text.trim();
    final breed = _breedController.text.trim();
    final age = int.tryParse(_ageController.text) ?? 0;
    final description = _descriptionController.text.trim();

    if (name.isEmpty || breed.isEmpty || age <= 0 || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos correctamente')),
      );
      return;
    }

    setState(() => _isSaving = true);
    _uploadAndPersist(name, breed, age, description);
  }

  Future<void> _uploadAndPersist(String name, String breed, int age, String description) async {
    final List<String> allImageUrls = List.from(_existingImageUrls);

    try {
      // Upload new images
      for (int i = 0; i < _imageBytesList.length; i++) {
        final fileName = '${widget.shelterId}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final url = await context.read<PetsCubit>().uploadPetImage(
              bytes: _imageBytesList[i],
              fileName: fileName,
            );
        allImageUrls.add(url);
      }

      final pet = PetEntity(
        id: widget.pet?.id ?? const Uuid().v4(),
        name: name,
        type: _selectedType,
        breed: breed,
        age: age,
        description: description,
        imageUrls: allImageUrls,
        shelterId: widget.shelterId,
        adopted: widget.pet?.adopted ?? false,
        createdAt: widget.pet?.createdAt ?? DateTime.now(),
      );

      if (widget.mode == PetFormMode.create) {
        await context.read<PetsCubit>().createPet(pet);
      } else {
        await context.read<PetsCubit>().updatePet(pet);
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickImage() async {
    final totalImages = _imageBytesList.length + _existingImageUrls.length;
    if (totalImages >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Máximo 5 imágenes permitidas')),
      );
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytesList.add(bytes);
        _imageNamesList.add(picked.name);
      });
    }
  }

  void _removeNewImage(int index) {
    setState(() {
      _imageBytesList.removeAt(index);
      _imageNamesList.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == PetFormMode.create
            ? 'Nueva mascota'
            : 'Editar mascota'),
        leading: const AppBackButton(
          fallbackRoute: AppRoutes.managePets,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: AppConstants.petTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedType = value);
              },
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _breedController,
              decoration: const InputDecoration(labelText: 'Raza'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Edad (meses)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Imágenes (hasta 5)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Grid of existing images
            if (_existingImageUrls.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _existingImageUrls.asMap().entries.map((entry) {
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(entry.value, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _removeExistingImage(entry.key),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            // Grid of new images
            if (_imageBytesList.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _imageBytesList.asMap().entries.map((entry) {
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(entry.value, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _removeNewImage(entry.key),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: (_existingImageUrls.length + _imageBytesList.length < maxImages)
                  ? _pickImage
                  : null,
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(
                'Agregar imagen (${_existingImageUrls.length + _imageBytesList.length}/$maxImages)',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
