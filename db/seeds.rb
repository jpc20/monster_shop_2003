# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
electronics_shop = Merchant.create(name: "Corey's Electronics Warehouse", address: '567 Elec Blvd', city: 'Denver', state: 'CO', zip: 80210)
oil_shop = Merchant.create(name: "Jane's Essential Oils", address: '357 Oil Blvd', city: 'Tulsa', state: 'OK', zip: 74104)
robe_shop = Merchant.create(name: "Max's Robes", address: '345 Compfy St', city: 'San Diego', state: 'CA', zip: 91945)
meat_shop = Merchant.create(name: "Jack's Meats", address: '923 Meat St', city: 'San Francisco', state: 'CA', zip: 91245)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
bike_horn = bike_shop.items.create(name: "Honk Honk", description: "Everyone will hear you comming", price: 20, image: "https://pbs.twimg.com/media/DkbR-8yVsAABrCg.png", inventory: 4)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#electronics_shop items
iphone_11_pro = electronics_shop.items.create(name: "iPhone 11 Pro", description: "Latest and Greatest from Apple!", price: 1000, image: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MWYK2?wid=2000&hei=2000&fmt=jpeg&qlt=95&op_usm=0.5,0.5&.v=1567304928359", inventory: 6)
dell_laptop = electronics_shop.items.create(name: "Dell Inspiron 15 Laptop", description: "Great laptop and great value", price: 300, image: "https://i.dell.com/is/image/DellContent//content/dam/global-site-design/product_images/dell_client_products/notebooks/inspiron_notebooks/15_3580/pdp/notebook-inspiron-15-3580-3581-na-pdp-gallery-504x350.jpg?fmt=jpg&wid=570&hei=400", inventory: 6)

#oil_shop items
full_synthetic = oil_shop.items.create(name: "Mobil 1", description: "Keep your car running smooth!", price: 5, image: "https://www.mobil.com/lubricants/-/media/project/wep/mobil/mobil-row-us-1/for-personal-vehicles/products-images/mobil-1-advanced-fuel-econ-0w-20-oil/mobil-1-advanced-fuel-econ-0w-20-oil-fs-product.jpg", inventory: 25)
synthetic_blend = oil_shop.items.create(name: "Pennzoil", description: "Good for yur high milage car!", price: 3, image: "https://images-na.ssl-images-amazon.com/images/I/81tDVKp0PCL._AC_SL1500_.jpg", inventory: 50)

#robe_shop items
silk_robe = robe_shop.items.create(name: "Momme", description: "Relax in this sild robe", price: 220, image: "https://images.lilysilk.com/media/catalog/product/cache/1/thumbnail/200x200/9df78eab33525d08d6e5fb8d27136e95/m/no/2302/22-momme-kontra-fuld-la-engde-silke-morgenkabe-2302-PUBLIC-2-20190826155402.jpg", inventory: 4)
smoking_jacket = robe_shop.items.create(name: "Satin", description: "Have a cigar and relax with this classic smoking jacket", price: 100, image: "https://cdn.shopify.com/s/files/1/2599/6536/products/828new_360x.jpg?v=1543235557", inventory: 4)

#meat_shop items
fillet = meat_shop.items.create(name: "Aged Wagyu", description: "It'll melt in your mouth", price: 200, image: "https://www.snakeriverfarms.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/s/r/srfbeef-goldmanfilet-raw_1_5.jpg", inventory: 10)
pork_shop = meat_shop.items.create(name: "Pork Chop", description: "All natural and organic pork", price: 8, image: "https://images.heb.com/is/image/HEBGrocery/001754756", inventory: 28)
