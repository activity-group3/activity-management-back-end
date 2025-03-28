package com.winnguyen1905.Activity.persistance.repository;

import java.util.List;

import org.springframework.boot.autoconfigure.data.web.SpringDataWebProperties.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.winnguyen1905.Activity.persistance.entity.EActivity;

@Repository
public interface ActivityRepository extends JpaRepository<EActivity, Long> {
} 
