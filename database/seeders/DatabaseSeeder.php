<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $this->call([
            BloodGroupsTableSeeder::class,
            NationalitiesTableSeeder::class,
            StatesTableSeeder::class,
            LgasTableSeeder::class,
            DormsTableSeeder::class,
            ClassTypesTableSeeder::class,
            UserTypesTableSeeder::class,
            MyClassesTableSeeder::class,
            SectionsTableSeeder::class,
            StudentRecordsTableSeeder::class,
            SettingsTableSeeder::class,
            ParentChildrenSeeder::class,
        ]);
    }
}
