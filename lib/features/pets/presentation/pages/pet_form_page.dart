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
  Uint8List? _imageBytes;
  String? _pickedImageName;
  String? _existingImageUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet!.name;
      _breedController.text = widget.pet!.breed;
      _ageController.text = widget.pet!.age.toString();
      _descriptionController.text = widget.pet!.description;
      _selectedType = widget.pet!.type;
      _existingImageUrl = widget.pet!.imageUrl;
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
    String? imageUrl = _existingImageUrl;

    try {
      if (_imageBytes != null) {
        final fileName = '${widget.shelterId}_${DateTime.now().millisecondsSinceEpoch}_${_pickedImageName ?? 'pet'}.jpg';
        imageUrl = await context.read<PetsCubit>().uploadPetImage(
              bytes: _imageBytes!,
              fileName: fileName,
            );
      }

      final pet = PetEntity(
        id: widget.pet?.id ?? const Uuid().v4(),
        name: name,
        type: _selectedType,
        breed: breed,
        age: age,
        description: description,
        imageUrl: imageUrl,
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
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _pickedImageName = picked.name;
      });
    }
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
                'Imagen (opcional)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _imageBytes != null
                    ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                    : (_existingImageUrl != null && _existingImageUrl!.isNotEmpty)
                        ? Image.network(_existingImageUrl!, fit: BoxFit.cover)
                        : const Center(
                            child: Icon(Icons.photo, size: 48, color: Colors.grey),
                          ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Seleccionar imagen'),
                ),
                const SizedBox(width: 12),
                if (_imageBytes != null || (_existingImageUrl?.isNotEmpty ?? false))
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _imageBytes = null;
                        _pickedImageName = null;
                        _existingImageUrl = null;
                      });
                    },
                    child: const Text('Quitar'),
                  ),
              ],
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
