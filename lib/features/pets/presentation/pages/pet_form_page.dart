import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petadopt_prueba2_app/features/pets/domain/entities/pet_entity.dart';
import 'package:petadopt_prueba2_app/features/pets/presentation/cubit/pets_cubit.dart';
import 'package:petadopt_prueba2_app/core/constants/app_constants.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet!.name;
      _breedController.text = widget.pet!.breed;
      _ageController.text = widget.pet!.age.toString();
      _descriptionController.text = widget.pet!.description;
      _selectedType = widget.pet!.type;
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

    final pet = PetEntity(
      id: widget.pet?.id ?? const Uuid().v4(),
      name: name,
      type: _selectedType,
      breed: breed,
      age: age,
      description: description,
      imageUrl: widget.pet?.imageUrl,
      shelterId: widget.shelterId,
      adopted: widget.pet?.adopted ?? false,
      createdAt: widget.pet?.createdAt ?? DateTime.now(),
    );

    if (widget.mode == PetFormMode.create) {
      context.read<PetsCubit>().createPet(pet);
    } else {
      context.read<PetsCubit>().updatePet(pet);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == PetFormMode.create
            ? 'Nueva mascota'
            : 'Editar mascota'),
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
            ElevatedButton(
              onPressed: _save,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
