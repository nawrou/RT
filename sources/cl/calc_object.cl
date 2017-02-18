/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   calc_object.cl                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lgatibel <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/02/13 11:11:30 by lgatibel          #+#    #+#             */
/*   Updated: 2017/02/13 11:11:39 by lgatibel         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "obj_def.h"
#include "calc.h"

float			float3_to_float(float3 v){
	return (v.x + v.y + v.z);
}

float3			norm(float delta, float3 ray_pos, float3 ray_dir)
{
	return ((ray_pos + ray_dir) * delta);
}

float3			ray_plane_norm(global t_obj *obj, float3 ray_pos, float3 ray_dir)
{
	float	div;
	float3	offset;

	offset = ray_pos - obj->pos;
	if ((div = float3_to_float(obj->rot * ray_dir)) == 0.0f)
		return (-1);
	return (norm((-float3_to_float(obj->rot * offset)) / div, ray_pos, ray_dir));
}

float3			ray_cone_norm(global t_obj *obj, float3 ray_pos, float3 ray_dir)
{
	float	a;
	float	b;
	float	c;
	float	delta;
	float3	offset;

	offset = ray_pos - obj->pos;
	a = dot(ray_dir.xz, ray_dir.xz) - dot(ray_dir.y, ray_dir.y);
	b = 2 * (dot(ray_dir.xz, offset.xz) - dot(ray_dir.y, ray_dir.y)) - (float)
	obj->radius * obj->radius;
	c = dot(offset.xz, offset.xz) - dot(offset.y, offset.y);
	if ((delta = calc_delta(a, b, c)) >= 0)
		return (norm(delta, ray_pos, ray_dir));
	return (-1);
}

float3			ray_cylinder_norm(global t_obj *obj, float3 ray_pos, float3 ray_dir)
{
	float	a;
	float	b;
	float	c;
	float	delta;
	float3	offset;

	offset = ray_pos - obj->pos;
	offset.y = 0;
	ray_dir.y = 0;
	a = dot(ray_dir, ray_dir);
	b = 2.0f * dot(ray_dir, offset);
	c = dot(offset, offset) - (float)obj->radius * obj->radius;
	if ((delta = calc_delta(a, b, c)) >= 0)
		return (norm(delta, ray_pos, ray_dir));
	return (-1);
}

float3			ray_sphere_norm(global t_obj *obj, float3 ray_pos, float3 ray_dir)
{
	float	a;
	float	b;
	float	c;
	float	delta;
	float3	offset;

	offset = ray_pos - obj->pos;
	a = dot(ray_dir, ray_dir);
	b = 2.0f * dot(ray_dir, offset);
	c = dot(offset, offset) - (float)(obj->radius * obj->radius);
	if ((delta = calc_delta(a, b, c)) >= 0.0f)
		return (norm(delta, ray_pos, ray_dir));
	return (-1);
}
