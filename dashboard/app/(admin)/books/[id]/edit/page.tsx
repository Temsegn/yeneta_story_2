"use client";

import { use } from "react";
import { ContentForm } from "@/components/content/content-form";

export default function EditBookPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  return <ContentForm kind="books" id={id} />;
}
