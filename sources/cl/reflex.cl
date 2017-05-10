static float3		reflex_is_light(t_data *data, float3 lightdir, global t_lgt *lgt, float3 normale)
{
	float3	light_clr;
	float3	save_intersect;

	data->ray_pos = lgt->pos;
	data->ray_dir = lightdir;
	save_intersect = data->intersect;
	while (data->id == data->through)
	{
		touch_object(data);
		data->ray_pos = data->intersect + data->ray_dir;
	}
	if ((data->id == data->through && fast_distance(save_intersect, lgt->pos) < 
	fast_distance(data->intersect, lgt->pos) + PREC) || data->id == data->through)
	{
		data->nl++;
		light_clr = calcul_clr(-lightdir, normale, lgt->clr * (data->objs[data->id].clr));
		// light_clr += is_shining(calcul_normale(data), -lightdir, lgt->clr);
		return (light_clr);
	}
	if (fast_distance(save_intersect, data->save_pos) < 
	fast_distance(data->intersect, data->save_pos)+ PREC)
		data->test++;
	return (0);
}

static float3		reflex_check_all_light(t_data *data)
{
	short	i;
	float3	lightdir;
	float3	rd_light;
	float3	normale;
	float3	clr;

	i = -1;
	rd_light = 0.0f;
	normale = 0; // a suprimer
	clr = data->objs[data->id].clr;
	while (++i < data->n_lgts)
	{
		lightdir = fast_normalize(data->intersect - data->lights[i].pos);
		rd_light += reflex_is_light(data, lightdir, &data->lights[i], normale);
	}
	rd_light += data->ambiant * clr * data->light_obj_pow;// a surement retirer
	if (!data->nl)
	 	return (rd_light);
	else if (data->n_lgts == 1)
		return (rd_light / (1.0f + data->ambiant));
		// return (rd_light / (1.0f + data->ambiant) * data->light_pow);
	return (rd_light  / (data->n_lgts - data->test + data->ambiant));
	// return (rd_light  / (data->n_lgts - data->test + data->ambiant) * data->light_pow);
}
void	calcul_reflex_ray(t_data *data)
{
	float3	normale;

	data->light_obj_pow = data->objs[data->id].reflex;
	data->light_pow -= data->objs[data->id].reflex;
	if (data->light_obj_pow <= 0.0f)
		return;
	normale = calcul_normale(data);
	data->ray_pos = data->intersect - data->ray_dir;
	data->ray_dir = fast_normalize(data->ray_dir - (2.0f * normale *
	dot(normale, data->ray_dir)));
	// data->ray_pos = data->intersect + data->ray_dir;
	touch_object(data);
	data->rd_light += reflex_check_all_light(data);
	// data->reflex = 0;
}
