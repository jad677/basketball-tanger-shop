-- Basketball Tanger Shop: run this script once in Supabase SQL Editor.
-- Demo products are intentionally unpublished until you verify prices, stock and photos.
create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
 );

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null default 'Accessoires',
  price numeric(10,2) not null default 0 check (price >= 0),
  stock integer not null default 0 check (stock >= 0),
  image_url text not null default '',
  sku text not null default '',
  emoji text not null default '🏀',
  description text not null default '',
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
 );

alter table public.admin_users enable row level security;
alter table public.products enable row level security;

drop policy if exists "Public can read published products" on public.products;
create policy "Public can read published products" on public.products for select using (published = true or exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

drop policy if exists "Admins can insert products" on public.products;
create policy "Admins can insert products" on public.products for insert with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

drop policy if exists "Admins can update products" on public.products;
create policy "Admins can update products" on public.products for update using (exists (select 1 from public.admin_users a where a.user_id = auth.uid())) with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

drop policy if exists "Admins can delete products" on public.products;
create policy "Admins can delete products" on public.products for delete using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

-- Admin allowlist is private: clients cannot read or modify it directly.
revoke all on public.admin_users from anon, authenticated;
grant select on public.products to anon, authenticated;
grant insert, update, delete on public.products to authenticated;

-- Seed demo catalogue. Run this file only once; all rows begin unpublished.
insert into public.products (name, category, price, stock, emoji, description, published, sku)
values
  ('Ballon basket outdoor', 'Ballons', 179, 0, '🏀', 'Ballon résistant pour jouer dehors.', false, 'DEMO-001'),
  ('Ballon basket indoor', 'Ballons', 249, 0, '🏀', 'Ballon pour terrain intérieur.', false, 'DEMO-002'),
  ('Ballon basket composite', 'Ballons', 299, 0, '🏀', 'Ballon composite polyvalent.', false, 'DEMO-003'),
  ('Ballon taille 7', 'Ballons', 199, 0, '🏀', 'Taille adulte officielle.', false, 'DEMO-004'),
  ('Ballon taille 6', 'Ballons', 189, 0, '🏀', 'Taille intermédiaire.', false, 'DEMO-005'),
  ('Ballon taille 5', 'Ballons', 159, 0, '🏀', 'Ballon pour jeunes joueurs.', false, 'DEMO-006'),
  ('Mini ballon basket', 'Ballons', 79, 0, '🏀', 'Mini ballon pour loisirs.', false, 'DEMO-007'),
  ('Pompe à ballon', 'Accessoires', 49, 0, '💨', 'Pompe manuelle compacte.', false, 'DEMO-008'),
  ('Aiguilles pour pompe', 'Accessoires', 15, 0, '📍', 'Lot d’aiguilles de rechange.', false, 'DEMO-009'),
  ('Filet de panier', 'Terrain', 59, 0, '🕸️', 'Filet de remplacement.', false, 'DEMO-010'),
  ('Maillot basket noir', 'Maillots', 199, 0, '👕', 'Maillot de basket style classique.', false, 'DEMO-011'),
  ('Maillot basket blanc', 'Maillots', 199, 0, '👕', 'Maillot léger blanc.', false, 'DEMO-012'),
  ('Maillot basket rouge', 'Maillots', 199, 0, '👕', 'Maillot rouge de basket.', false, 'DEMO-013'),
  ('Maillot basket bleu', 'Maillots', 199, 0, '👕', 'Maillot bleu de basket.', false, 'DEMO-014'),
  ('Short basket noir', 'Vêtements', 129, 0, '🩳', 'Short respirant.', false, 'DEMO-015'),
  ('Short basket blanc', 'Vêtements', 129, 0, '🩳', 'Short léger pour entraînement.', false, 'DEMO-016'),
  ('Short basket rouge', 'Vêtements', 129, 0, '🩳', 'Short rouge.', false, 'DEMO-017'),
  ('Débardeur entraînement', 'Vêtements', 99, 0, '👕', 'Débardeur sport.', false, 'DEMO-018'),
  ('T-shirt basket', 'Vêtements', 119, 0, '👕', 'T-shirt pour joueurs.', false, 'DEMO-019'),
  ('Sweat basket', 'Vêtements', 249, 0, '🧥', 'Sweat confortable.', false, 'DEMO-020'),
  ('Chaussettes sport', 'Vêtements', 49, 0, '🧦', 'Chaussettes de sport.', false, 'DEMO-021'),
  ('Chaussettes montantes', 'Vêtements', 59, 0, '🧦', 'Chaussettes montantes.', false, 'DEMO-022'),
  ('Manchons bras', 'Compression', 69, 0, '💪', 'Manchons de compression.', false, 'DEMO-023'),
  ('Manchon jambe', 'Compression', 79, 0, '🦵', 'Manchon de soutien.', false, 'DEMO-024'),
  ('Manchons jambes paire', 'Compression', 129, 0, '🦵', 'Paire de manchons.', false, 'DEMO-025'),
  ('Genouillère basket', 'Protection', 89, 0, '🛡️', 'Protection pour le genou.', false, 'DEMO-026'),
  ('Chevillère sport', 'Protection', 79, 0, '🛡️', 'Maintien de la cheville.', false, 'DEMO-027'),
  ('Coudière sport', 'Protection', 69, 0, '🛡️', 'Protection pour le coude.', false, 'DEMO-028'),
  ('Bandeau tête', 'Accessoires', 39, 0, '🎽', 'Bandeau absorbant.', false, 'DEMO-029'),
  ('Poignets éponge', 'Accessoires', 35, 0, '🎽', 'Paire de poignets éponge.', false, 'DEMO-030'),
  ('Sac à dos basket', 'Sacs', 249, 0, '🎒', 'Sac de sport avec compartiments.', false, 'DEMO-031'),
  ('Sac de sport', 'Sacs', 199, 0, '🎒', 'Sac pour entraînement.', false, 'DEMO-032'),
  ('Sac à chaussures', 'Sacs', 69, 0, '👟', 'Pochette pour chaussures.', false, 'DEMO-033'),
  ('Gourde sport', 'Accessoires', 59, 0, '🥤', 'Gourde réutilisable.', false, 'DEMO-034'),
  ('Serviette sport', 'Accessoires', 49, 0, '🧺', 'Serviette compacte.', false, 'DEMO-035'),
  ('Corde à sauter', 'Entraînement', 59, 0, '➰', 'Corde pour échauffement.', false, 'DEMO-036'),
  ('Échelle d’agilité', 'Entraînement', 149, 0, '⚡', 'Travail des appuis.', false, 'DEMO-037'),
  ('Cônes entraînement lot', 'Entraînement', 79, 0, '🔺', 'Cônes pour exercices.', false, 'DEMO-038'),
  ('Sifflet coach', 'Accessoires', 29, 0, '📣', 'Sifflet pour entraînement.', false, 'DEMO-039'),
  ('Chronomètre sport', 'Accessoires', 89, 0, '⏱️', 'Chronomètre simple.', false, 'DEMO-040'),
  ('Bande de résistance légère', 'Entraînement', 39, 0, '💪', 'Bande élastique légère.', false, 'DEMO-041'),
  ('Bande de résistance moyenne', 'Entraînement', 49, 0, '💪', 'Bande élastique moyenne.', false, 'DEMO-042'),
  ('Bande de résistance forte', 'Entraînement', 59, 0, '💪', 'Bande élastique forte.', false, 'DEMO-043'),
  ('Mini haies agilité', 'Entraînement', 179, 0, '⚡', 'Haies pour coordination.', false, 'DEMO-044'),
  ('Pompe électrique ballon', 'Accessoires', 199, 0, '💨', 'Pompe électrique compacte.', false, 'DEMO-045'),
  ('Sac filet pour ballons', 'Sacs', 79, 0, '🏀', 'Transport de ballons.', false, 'DEMO-046'),
  ('Support téléphone coach', 'Accessoires', 89, 0, '📱', 'Support pour filmer les exercices.', false, 'DEMO-047'),
  ('Ruban de grip', 'Accessoires', 39, 0, '🧵', 'Ruban de maintien.', false, 'DEMO-048'),
  ('Lacets sport', 'Accessoires', 25, 0, '👟', 'Lacets de rechange.', false, 'DEMO-049'),
  ('Semelles sport', 'Accessoires', 99, 0, '👟', 'Semelles de confort.', false, 'DEMO-050'),
  ('Chaussures basket entrée de gamme', 'Chaussures', 499, 0, '👟', 'Chaussures pour entraînement.', false, 'DEMO-051'),
  ('Chaussures basket indoor', 'Chaussures', 699, 0, '👟', 'Chaussures pour parquet.', false, 'DEMO-052'),
  ('Chaussures basket outdoor', 'Chaussures', 599, 0, '👟', 'Chaussures pour terrain extérieur.', false, 'DEMO-053'),
  ('Chaussures basket montantes', 'Chaussures', 649, 0, '👟', 'Modèle montant.', false, 'DEMO-054'),
  ('Protège-chevilles paire', 'Protection', 99, 0, '🛡️', 'Protection légère.', false, 'DEMO-055'),
  ('Genouillères paire', 'Protection', 149, 0, '🛡️', 'Paire de genouillères.', false, 'DEMO-056'),
  ('Manchons compression paire', 'Compression', 119, 0, '💪', 'Paire de compression.', false, 'DEMO-057'),
  ('Sac à ballon individuel', 'Sacs', 69, 0, '🏀', 'Housse pour un ballon.', false, 'DEMO-058'),
  ('Porte-clés basket', 'Cadeaux', 19, 0, '🔑', 'Petit cadeau basket.', false, 'DEMO-059'),
  ('Bracelet basket', 'Cadeaux', 25, 0, '🧡', 'Bracelet style basket.', false, 'DEMO-060'),
  ('Poster basket', 'Cadeaux', 49, 0, '🖼️', 'Poster décoratif.', false, 'DEMO-061'),
  ('Mini panier de porte', 'Terrain', 149, 0, '🏀', 'Mini panier de loisir.', false, 'DEMO-062'),
  ('Panier portable jouet', 'Terrain', 299, 0, '🏀', 'Panier compact de loisir.', false, 'DEMO-063'),
  ('Filet de rangement équipement', 'Sacs', 89, 0, '🕸️', 'Rangement d’équipement.', false, 'DEMO-064'),
  ('Sac de rangement chaussures', 'Sacs', 79, 0, '👟', 'Pochette de rangement.', false, 'DEMO-065'),
  ('Bouteille squeeze', 'Accessoires', 45, 0, '🥤', 'Bouteille sport souple.', false, 'DEMO-066'),
  ('Bandeau poignet duo', 'Accessoires', 35, 0, '🎽', 'Deux bandeaux de poignet.', false, 'DEMO-067'),
  ('Serviette microfibre', 'Accessoires', 69, 0, '🧺', 'Séchage rapide.', false, 'DEMO-068'),
  ('Pochette accessoires', 'Sacs', 59, 0, '🎒', 'Petite pochette.', false, 'DEMO-069'),
  ('T-shirt entraînement noir', 'Vêtements', 119, 0, '👕', 'T-shirt respirant.', false, 'DEMO-070'),
  ('T-shirt entraînement blanc', 'Vêtements', 119, 0, '👕', 'T-shirt respirant blanc.', false, 'DEMO-071'),
  ('Short compression', 'Compression', 89, 0, '🩳', 'Short ajusté pour sport.', false, 'DEMO-072'),
  ('Legging sport', 'Vêtements', 149, 0, '🩳', 'Legging de sport.', false, 'DEMO-073'),
  ('Maillot réversible', 'Maillots', 229, 0, '👕', 'Maillot deux couleurs.', false, 'DEMO-074'),
  ('Chasubles entraînement lot', 'Entraînement', 159, 0, '🎽', 'Chasubles pour équipes.', false, 'DEMO-075'),
  ('Tableau coach effaçable', 'Entraînement', 179, 0, '📋', 'Tableau tactique portable.', false, 'DEMO-076'),
  ('Pochette de coach', 'Sacs', 99, 0, '📋', 'Pochette pour accessoires.', false, 'DEMO-077'),
  ('Pompe avec manomètre', 'Accessoires', 99, 0, '💨', 'Pompe avec indicateur de pression.', false, 'DEMO-078'),
  ('Aiguilles de pompe lot', 'Accessoires', 25, 0, '📍', 'Lot de rechange.', false, 'DEMO-079'),
  ('Kit entraînement basket', 'Packs', 249, 0, '🏀', 'Kit de petits accessoires.', false, 'DEMO-080'),
  ('Pack joueur débutant', 'Packs', 399, 0, '🎁', 'Pack pour débuter.', false, 'DEMO-081'),
  ('Pack accessoires joueur', 'Packs', 199, 0, '🎁', 'Accessoires essentiels.', false, 'DEMO-082'),
  ('Pack entraînement équipe', 'Packs', 599, 0, '🎁', 'Équipement d’entraînement.', false, 'DEMO-083'),
  ('Pack ballon et pompe', 'Packs', 219, 0, '🎁', 'Ballon avec pompe.', false, 'DEMO-084'),
  ('Pack chaussettes et bandeau', 'Packs', 79, 0, '🎁', 'Accessoires textiles.', false, 'DEMO-085'),
  ('Pack protection', 'Packs', 199, 0, '🛡️', 'Sélection de protections.', false, 'DEMO-086'),
  ('Pack coach', 'Packs', 299, 0, '📋', 'Accessoires de coach.', false, 'DEMO-087');

-- After creating your Supabase Auth user, copy its UUID and run:
-- insert into public.admin_users (user_id) values ('PASTE-AUTH-USER-UUID-HERE');
-- Keep the Supabase service_role key private; use only the public anon/publishable key in the website.
