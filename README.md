# Monster Shop
### BE Mod 2 Week 4/5 Group Project

<p align="center">
  <a href="https://pure-waters-06944.herokuapp.com/">View our Monster Shop 2003</a>
 </p>

### Team
<p>
<a href="https://github.com/jpc20">Jack Cullen</a>
</p>
<p>
<a href="https://github.com/janegreene">Jane Greene</a>
</p>
<p>
<a href="https://github.com/Lithnotep">Max Mitrani </a>
</p>
<p>
<a href="https://github.com/Ashkanthegreat"> Ashkan Abbasi</a>
</p>

## Background and Description

"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will be able to get "shipped" by an admin. Each user role will have access to some or all CRUD functionality for application models

## Tech
- Rails 5.1.x
- PostgreSQL

### Gems
- rspec-rails
- capybara
- launchy
- pry
- simplecov
- shoulda-matchers
- factory_bot_rails
- orderly

# Getting Started
## Prerequisites
```javascript
brew install ruby -2.5.3
gem install rails -5.1.7
```
## Installing
#### Clone repository:
```javascript
git clone git@github.com:jpc20/monster_shop_2003.git
```
#### Navigate into directory:
```javascript
cd monster_shop_2003
```
#### Install gems:
```javascript
bundle install
```
#### Configure databases:
```javascript
rails db:{create,migrate,seed}
```
#### Fire up local server: (http://localhost:3000)
```javascript
rails s
```
#### Run test suite:
```javascript
bundle exec rspec
```

## User Roles

1. Visitor - this type of user is anonymously browsing our site and is not logged in
2. Regular User - this user is registered and logged in to the application while performing their work; can place items in a cart and create an order
3. Merchant Employee - this user works for a merchant. They can fulfill orders on behalf of their merchant. They also have the same permissions as a regular user (adding items to a cart and checking out)
4. Admin User - a registered user who has "superuser" access to all areas of the application; user is logged in to perform their work
---

## Register
 <p align="center">
 <img src="https://i.imgur.com/MvpbVUi.png">
</p>


## Merchants
<p align="center">
 <img src="https://i.imgur.com/gXzTqW8.png">
</p>

## Merchants Dashboard
<p align="center">
 <img src="https://i.imgur.com/arThtw9.png">
</p>


## Items Index
<p align="center">
 <img src="https://i.imgur.com/JbmDfpX.png">
</p>


## Item Show Page
<p align="center">
 <img src="https://i.imgur.com/5LBorFk.png">
</p>


 ### If you are interested in contributing:
- Fork repo (https://github.com/Lithnotep/monster_shop_2003)
- Create your feature branch (`git checkout -b feature/fooBar`)
- Commit your changes (`git commit -m 'Add some fooBar'`)
- Push to the branch (`git push origin feature/fooBar`)
- Create a new Pull Request
