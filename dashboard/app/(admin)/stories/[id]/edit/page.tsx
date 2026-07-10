"use client";

import { use } from "react";
import { ContentForm } from "@/components/content/content-form";

export default function EditStoryPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  return <ContentForm kind="stories" id={id} />;
}
