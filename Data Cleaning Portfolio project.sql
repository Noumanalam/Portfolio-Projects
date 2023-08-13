select * from NashvilleHousing


--Standardize Date Format

Select saleDate, CONVERT(Date,SaleDate)
From NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


--Populate Property Address data 

Select *
From NashvilleHousing
--Where PropertyAddress is null
order by ParcelID
 
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID= b.ParcelID
	and a. [UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = isnull (a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID= b.ParcelID
	and a. [UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null
	
--Breaking out address into induividual columns (address, city, state)

Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID
 
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

from nashvillehousing

Alter table nashvillehousing
add propertysplitaddress nvarchar(255);

update NashvilleHousing
set propertysplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

alter table nashvillehousing
add propertysplitcity nvarchar(255);

update NashvilleHousing
set propertysplitaddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


select * 
from NashvilleHousing

select OwnerAddress 
from NashvilleHousing

select 
PARSENAME(replace(owneraddress, ',', '.'), 3) as address
,PARSENAME(replace(owneraddress, ',', '.'), 2) as cityname
,PARSENAME(replace(owneraddress, ',', '.'), 1) as statename
from NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


select * from NashvilleHousing



-- Remove Duplicate


with rownumCTE as (
select *,
row_number() over (
partition by  parcelID,
			propertyaddress,
			saleprice,
			saledate,
			legalreference
			order by 
			uniqueID
			) row_num
from NashvilleHousing
--order by ParcelID
)
select * from rownumCTE
where row_num > 1
--order by propertyaddress


--delete usused columns

select * from NashvilleHousing

alter table nashvillehousing
drop column owneraddress, taxdistrict, propertyaddress


alter table nashvillehousing
drop column saledate