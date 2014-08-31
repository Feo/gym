package com.cn.assistantmember.listener;

import com.cn.assistantmember.entity.BaseEntity;
public interface RequestCompleteListener<T extends BaseEntity> {

	public void onRequestCompleteListener(T entity);

}
