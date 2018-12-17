!=================================================================================================================================
! Copyright (c) 2010-2016  Prof. Claus-Dieter Munz
! This file is part of FLEXI, a high-order accurate framework for numerically solving PDEs with discontinuous Galerkin methods.
! For more information see https://www.flexi-project.org and https://nrg.iag.uni-stuttgart.de/
!
! FLEXI is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
! as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
!
! FLEXI is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
! of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License v3.0 for more details.
!
! You should have received a copy of the GNU General Public License along with FLEXI. If not, see <http://www.gnu.org/licenses/>.
!=================================================================================================================================
!===================================================================================================================================
!> Contains global variables used for/by the RPSet
!===================================================================================================================================
MODULE MOD_RPSet_Vars
! MODULES
IMPLICIT NONE
PUBLIC
SAVE
!-----------------------------------------------------------------------------------------------------------------------------------
! GLOBAL VARIABLES 
!-----------------------------------------------------------------------------------------------------------------------------------
LOGICAL                         :: RPSetInitIsDone=.FALSE.
INTEGER                         :: nRP_global
INTEGER                         :: nGroups,nLines,nPoints,nPlanes
INTEGER,ALLOCATABLE             :: OffsetRP(:,:)

TYPE tGroup
  CHARACTER(LEN=255)               :: Name
  INTEGER                          :: ID
  INTEGER                          :: nRP
  TYPE(tRP_Ptr),POINTER            :: RP_ptr(:)
END TYPE tGroup

TYPE tLine
  CHARACTER(LEN=255)               :: Name
  INTEGER                          :: GroupID
  REAL                             :: xStart(3)
  REAL                             :: xEnd(3)
  INTEGER                          :: nRP
  TYPE(tRP_Ptr),POINTER            :: RP_ptr(:)
END TYPE tLine

TYPE tPlane
  CHARACTER(LEN=255)               :: Name
  INTEGER                          :: GroupID
  REAL                             :: x(3,4) ! 4 corner points
  INTEGER                          :: nRP(2) ! RP resolution in i,j direction i: P1->P2, 
  TYPE(tRP_Ptr),POINTER            :: RP_ptr(:,:) !                           j: P1->P4.
  REAL,ALLOCATABLE                 :: NormVec(:,:),TangVec(:,:)
END TYPE tPlane

TYPE tPoint
  INTEGER                          :: GroupID
  TYPE(tRP),POINTER                :: RP
END TYPE tPoint

TYPE tRP
  INTEGER                          :: ID
  INTEGER                          :: ElemID
  INTEGER                          :: GroupID
  REAL                             :: xi(3)
  REAL                             :: x(3)
  REAL                             :: xF(3)
END TYPE tRP

TYPE tRPlist
  TYPE(tRP),POINTER                :: RP
END TYPE tRPlist

TYPE tRP_Ptr 
  TYPE(tRP),POINTER                :: RP                     ! node pointer
END TYPE tRP_Ptr 



TYPE(tPlane),POINTER            :: Planes(:)
TYPE(tLine),POINTER             :: Lines(:)
TYPE(tPoint),POINTER            :: Points(:)
TYPE(tGroup),POINTER            :: Groups(:)
TYPE(tRPlist),POINTER           :: RPlist(:)

INTERFACE GetNewRP
  MODULE PROCEDURE GetNewRP
END INTERFACE

PUBLIC:: GetNewRP
!===================================================================================================================================

CONTAINS

SUBROUTINE GetNewRP(RP,GroupID,x)
!===================================================================================================================================
! Subroutine to write 3D point data to VTK format
! MODULES
! IMPLICIT VARIABLE HANDLING
IMPLICIT NONE
!-----------------------------------------------------------------------------------------------------------------------------------
! INPUT VARIABLES
TYPE(tRP),POINTER ::  RP
INTEGER           ::  GroupID
REAL              ::  x(3)
!-----------------------------------------------------------------------------------------------------------------------------------
! OUTPUT VARIABLES
!-----------------------------------------------------------------------------------------------------------------------------------
! LOCAL VARIABLES
!===================================================================================================================================
ALLOCATE(RP)
nRP_global=nRP_global+1
RP%ID=nRP_global
RP%ElemID=-1
RP%GroupID=GroupID
Groups(GroupID)%nRP= Groups(GroupID)%nRP+1
RP%xi=HUGE(9.)
RP%xF=HUGE(9.)
RP%x(1:3)=x(1:3)
!WRITE(*,*) 'id,groupid',RP%ID,RP%GroupID

END SUBROUTINE GetNewRP

END MODULE MOD_RPSet_Vars
