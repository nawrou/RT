/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   light.cl                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: erodrigu <erodrigu@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/02/09 15:39:48 by erodrigu          #+#    #+#             */
/*   Updated: 2017/02/09 15:39:48 by erodrigu         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "reflex.cl"
#include "refract.cl"
#include "shiness.cl"
#include "light.h"
#include "color.cl"

unsigned	get_lighting(t_data *data)
{
	// temp_pos = data->intersect;
	// while (data->safe > 0 && data->light_pow > 0.0f)
	// {

	// 	if (data->objs[data->id].reflex > 0.0f)
	// 	{
	// 		calcul_reflex_color(data);
	// 	}
	// 	else if (data->objs[data->id].opacity < 1.0f)
	// 	{
	// 		break ;// WIP
	// 	}
	// 	else
	// 		break ;
	// }
	data->rd_light = check_all_light(data);
	return(calcul_rendu_light(data));
}

float3		check_all_light(t_data *data)
{
	short	i = -1;
	float3	lightdir;
	float3	rd_light;
	float3	normale;

	rd_light = 0.0f;
	normale = calcul_normale(data);
	// printf("lighs[%u]",data->n_lgts);
	rd_light = 0.0f;
	while (++i < data->n_lgts)
	{
		lightdir = fast_normalize(data->save_inter - data->lights[i].pos);
		rd_light += is_light(data, lightdir, &data->lights[i], normale);
	}
	rd_light += calcul_clr(data->save_dir, -normale, data->ambiant * data->save_clr, &data->objs[data->save_id])
	* data->objs[data->id].opacity * data->light_pow;
	if (!data->nl)
	 	return (rd_light);
	else if (data->n_lgts == 1)
		return (rd_light + (rd_light * (data->nl / 10.0f)) / data->n_lgts);
	return ((rd_light + (rd_light * (data->nl) / 10.0f)) / (data->n_lgts - data->test));
}

float3		is_light(t_data *data, float3 lightdir, global t_lgt *lgt, float3 normale)
{
	float3	light_clr;

	data->ray_pos = lgt->pos;
	data->ray_dir = lightdir;
	touch_object(data);
	if (data->id == data ->save_id && fast_distance(data->save_inter, lgt->pos) < 
		fast_distance(data->intersect, lgt->pos) + PREC)
	{
		data->nl++;
		light_clr = calcul_clr(-lightdir, normale, lgt->clr * data->save_clr, &data->objs[data->save_id]);
		// light_clr += is_shining(calcul_normale(data), -lightdir, 0.8f, 150.0f, lgt->clr);
		return (light_clr );
	}
	if (fast_distance(data->save_inter, data->save_pos) < fast_distance(data->intersect, data->save_pos)+ PREC)
		data->test++;
	return (0);
	// data->objs n'est pas utilise
	// a deux endroit la et la haut
}
